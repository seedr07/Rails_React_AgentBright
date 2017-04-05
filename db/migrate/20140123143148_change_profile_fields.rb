class ChangeProfileFields < ActiveRecord::Migration
  def change
    remove_column :profiles, :photo
    remove_column :profiles, :mobile_number
    add_column :profiles, :time_zone, :string
    add_column :profiles, :company_website, :string
  end
end
