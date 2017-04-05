class AddTsListToMandrillMessages < ActiveRecord::Migration
  def change
    add_column :mandrill_messages, :activity_ts_list, :string, default: ""
  end
end
