module AlertsHelper

  def show_alert_if_processing_csv_file(user)
    if user.pending_csv_file?
      render(partial: "shared/alerts/csv_file_processing")
    end
  end

end
