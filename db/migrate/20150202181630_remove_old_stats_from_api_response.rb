class RemoveOldStatsFromApiResponse < ActiveRecord::Migration
  def change
    remove_column :api_responses, :fullcontact_last_called, :datetime
    remove_column :api_responses, :kimono_last_called, :datetime
    remove_column :api_responses, :inboxapp_last_called, :datetime
    remove_column :api_responses, :mandrill_last_called, :datetime
    remove_column :api_responses, :twilio_last_called, :datetime
    remove_column :api_responses, :stripe_last_called, :datetime
    remove_column :api_responses, :fullcontact_status, :string
    remove_column :api_responses, :fullcontact_message, :string
    remove_column :api_responses, :kimono_status, :string
    remove_column :api_responses, :kimono_message, :string
    remove_column :api_responses, :inboxapp_status, :string
    remove_column :api_responses, :inboxapp_message, :string
    remove_column :api_responses, :mandrill_status, :string
    remove_column :api_responses, :mandrill_message, :string
    remove_column :api_responses, :twilio_status, :string
    remove_column :api_responses, :twilio_message, :string
    remove_column :api_responses, :stripe_status, :string
    remove_column :api_responses, :stripe_message, :string
    add_column :api_responses, :api_type, :string
    add_column :api_responses, :api_called_at, :datetime
    add_column :api_responses, :status, :string
    add_column :api_responses, :message, :string
  end
end
