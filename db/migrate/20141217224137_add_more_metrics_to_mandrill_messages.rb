class AddMoreMetricsToMandrillMessages < ActiveRecord::Migration
  def change
    add_column :mandrill_messages, :last_clicked, :integer, default: 0
    add_column :mandrill_messages, :last_opened, :integer, default: 0
  end
end
