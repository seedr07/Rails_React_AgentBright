class FixFranchiseFeeBooleanInUser < ActiveRecord::Migration

  def change
    change_column :users, :franchise_fee, :boolean, default: false, null: false

    User.reset_column_information

    User.all.each do |user|
      if user.franchise_fee.nil?
        user.franchise_fee = false
        Util.log "\nUser =>      #{user.name}"
        Util.log "\nUser =>      #{user.inspect}"
        user.save
      end

    end
  end

end
