module DropdownsHelper

  def drop_link(text, path, condition=false, options={})
    class_name = (current_page?(path) || condition) ? "active" : ""

    content_tag(:li, class: class_name) do
      options[:title] = text unless options.has_key?(:title)
      options[:tabindex] = "-1" unless options.has_key?(:tabindex)
      if options.has_key?(:class)
        options[:class] = options[:class] + "with-ripple"
      else
        options[:class] = "with-ripple"
      end

      link_to(text, path, options)
    end
  end

end
