class AddClientResponseLastCheckedAtToInboxMessages < ActiveRecord::Migration
  def change
    add_column :inbox_messages, :client_response_last_checked_at, :datetime
  end
end
