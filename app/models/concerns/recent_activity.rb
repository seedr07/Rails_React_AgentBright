module RecentActivity
  extend ActiveSupport::Concern

  included do
    ##
    # :activity_parameters_changes => It will be used to save only required
    # parameters in public activity table
    attr_accessor :activity_parameters_changes

    ##
    # :set_activity_parameters_changes => before save callback will be used
    # to calculcate and set only required parameters to
    # 'activity_parameters_changes' attribute
    before_save :set_activity_parameters_changes

    after_save :clear_activity_parameters_changes

    class_eval do
      ##
      # :recent_activities_for => We can pass required associations and
      # attributes to this method.
      #
      # parameters structure for this method is given below,
      #
      # recent_activities_for self: { attributes: [:attr1, attr2] },
      #                       associations: { user: {
      #                         attributes: [:attr1, :attr2] },
      #                                      :projects: {
      #                         attributes: [:attr1, :attr2] }
      #                         }
      #
      # We can pass association based on has_one, belongs_to and has_many. So
      # association symobl must be in singular and plural forms (little like
      # Rails conventions)

      def self.recent_activities_for(args)
        @_recent_activities_for = args
      end

      ##
      # :extend_recent_activities_for => We can pass required associations to
      # this method. For each association, we need a condition, so based on it,
      # we can extend SQL query for recent_activities method.
      #
      # parameters structure for this method is given below,
      #
      # extend_recent_activities_for tasks: { condition: ->(model) do
      #                                                    {
      #                                                     key1: model.key1_value,
      #                                                     key2: model.key1_value,
      #                                                     other_key: ["value1",
      #                                                                 "value1",
      #                                                                 "value2"]
      #                                                    }
      #                                                  end } }

      def self.extend_recent_activities_for(args)
        @_extend_recent_activities_for = args
      end
    end
  end

  module ClassMethods
    def get_recent_activities_for
      @_recent_activities_for ||= {}
    end

    def get_extend_recent_activities_for
      @_extend_recent_activities_for ||= {}
    end

    def activity_attributes_for(association)
      attributes = []
      if association == :self
        self_association = get_recent_activities_for[:self]
        attributes = self_association[:attributes] if self_association
      else
        attributes = get_recent_activities_for[:associations][association][:attributes]
      end
      attributes = [attributes] unless attributes.is_a? Array

      attributes
    end
  end

  ##
  # Gives recent activities for an object. An object's model should have
  # included PublicActivity::Model module from public_activity gem.
  #
  # Takes an options hash, in which we can set number of records we want
  # (default limit is 10), show activities based on date and date format.
  #
  # default options:
  #  {
  #    limit: 10,
  #    group_by_date: false,
  #    date_format: "%A, %B %-d",
  #  }
  #
  def recent_activities(options = {})
    @_activities_options = default_activities_options.merge(options)

    activities = PublicActivity::Activity.
                 where(query).
                 order("created_at desc").
                 distinct.
                 page(@_activities_options[:page]).
                 per(10)

    if @_activities_options[:group_by_date]
      activities = activities.group_by do |activitiy|
        activitiy.created_at.strftime(@_activities_options[:date_format])
      end
    end

    activities
  end

  private

  def default_activities_options
    {
      page: nil,
      group_by_date: false,
      date_format: "%A, %B %-d",
    }
  end

  def query
    main_query  = "trackable_id = ? AND trackable_type = ?"
    main_query_values = [self.id, self.class.to_s]

    extend_activities_for = self.class.get_extend_recent_activities_for

    if extend_activities_for.present?
      main_query, main_query_values = extend_activities(
        extend_activities_for,
        main_query,
        main_query_values
      )
    end

    [main_query] + main_query_values
  end

  def children_associations_options
    @_children_associations_options ||= self.class.get_recent_activities_for[:associations]
  end

  def set_activity_parameters_changes
    required_changes = required_changes(changes, self.class.activity_attributes_for(:self))

    if self.activity_parameters_changes.blank?
      self.activity_parameters_changes = required_changes
    else
      self.activity_parameters_changes.merge! required_changes
    end

    set_children_parameters_changes if children_associations_options.present?
  end

  def set_children_parameters_changes
    @_children_associations_options.keys.map do |association|
      next if public_send(association).nil?

      if public_send(association).respond_to?(:to_a)
        select_valid_children(association).each.with_index(1) do |child, index|
          set_child_parameters_changes(child, association, index)
        end
      else
        child = public_send(association)
        set_child_parameters_changes(child, association) if child_modified?(child)
      end
    end
  end

  def select_valid_children(child_association)
    public_send(child_association).select { |child| child_modified?(child) }
  end

  def set_child_parameters_changes(child, association, index=0)
    child_changes = {}

    if child.changes.present?
      child_changes = remove_unwanted_data(child.changes)
      child_changes = keep_changes(child_changes, self.class.activity_attributes_for(association))
      child_changes = remap_child_changes(child_changes, index, association)
    end

    # NOTE: This code should be decoupled.
    if child.marked_for_destruction?
      key, value = "", ""

      if association == :email_addresses
        key = "email"
        value = child.email
      end

      if association == :phone_numbers
        key = "number"
        value = child.number
      end

      child_changes = { "#{key}" => [value, "deleted"] }
      child_changes = remap_child_changes(child_changes, index, association)
    end

    self.activity_parameters_changes.merge!(child_changes)
  end

  def remap_child_changes(child_changes, index, association)
    remapped_child_changes = {}

    child_changes.each do |key, value|
      next if same_elements_in?(value)
      index = "" if index == 0
      remapped_child_changes["#{association.to_s.singularize}_#{key}#{index}"] = value
    end

    remapped_child_changes
  end

  def required_changes(all_changes, keep_attributes)
    showable_changes = remove_unwanted_data(all_changes)
    showable_changes = keep_changes(showable_changes, keep_attributes)
    showable_changes
  end

  def keep_changes(changes, keep_attributes)
    return changes if keep_attributes.blank?

    changes.keep_if do |key, _|
      keep_attributes.include? key.to_sym
    end
  end

  def remove_unwanted_data(hash)
    hash.delete(:id)
    hash
  end

  def same_elements_in?(value)
    return true if value.first.nil? && value.last.nil?
    return false if value.first.nil? || value.last.nil?

    value.first.to_s.strip == value.last.to_s.strip
  end

  def child_modified?(child)
    child.changes.present? || child.marked_for_destruction?
  end

  def extend_activities(extend_activities_for, main_query, main_query_values)
    extend_activities_for.keys.each do |association|
      main_query << " OR "
      extented_query  = []
      extented_values = []

      proc_object = extend_activities_for[association][:condition]
      condition   = proc_object.(self)

      condition.keys.each do |attribute|
        if condition[attribute].is_a? Array
          extented_query << " #{attribute} in (?)"
        else
          extented_query << " #{attribute} = ?"
        end

        extented_values << condition[attribute]
      end

      main_query << "(#{extented_query.join(" AND ")})"
      main_query_values += extented_values
    end

    [main_query, main_query_values]
  end

  def clear_activity_parameters_changes
    self.activity_parameters_changes = {}
  end
end
