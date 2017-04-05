class AddMetricsToMandrillMessages < ActiveRecord::Migration
  def change
    add_column :mandrill_messages, :opens, :integer, default: 0
    add_column :mandrill_messages, :opens_detail, :string, default: ""
    add_column :mandrill_messages, :clicks, :integer, default: 0
    add_column :mandrill_messages, :clicks_detail, :string, default: ""
    add_column :mandrill_messages, :state, :string, default: 0
  end
end
