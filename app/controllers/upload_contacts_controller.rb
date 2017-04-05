class UploadContactsController < ApplicationController

  def new
    @csv_file = CsvFile.new.csv
    @csv_file.success_action_redirect = create_csv_file_upload_contacts_url
  end

  def create_csv_file
    # NOTE: We had to create this method separately because S3 sends callback
    # requets in 'GET' format.
    @csv_file = current_user.csv_files.build
    @csv_file.key = params[:key]

    if @csv_file.filename_valid? && @csv_file.save
      import_csv_file
      flash[:notice] = "CSV file #{@csv_file.filename} has been successfully "\
      "stored on the server. We will process the data and will email you once "\
      "it is done. It is typically done within an hour"
      redirect_to dashboard_url
    else
      flash[:error] = csv_file_errors
      redirect_to :back
    end
  end

  def show
    @csv_file = current_user.csv_files.find(params[:id])
  end

  def create
    # NOTE: Not sure this method is being used somewhere else. If not then we
    # need to remove it as we already handled same code in 'create_csv_file' action.

    @csv_file = build_csv_file_from_params

    if @csv_file.save
      import_csv_file
      flash[:notice] = "CSV file #{@csv_file.filename} has been successfully "\
      "stored on the server. We will process the data and will email you once "\
      "it is done. It is typically done within an hour"
      redirect_to dashboard_url
    else
      flash[:error] = csv_file_errors
      redirect_to :back
    end
  end

  private

  def build_csv_file_from_params
    current_user.csv_files.build(csv_file_params)
  end

  def import_csv_file
    ImportCsvFileJob.perform_later(@csv_file.id)
  end

  def csv_file_errors
    @csv_file.errors.full_messages.to_sentence
  end

  def csv_file_params
    params.require(:csv_file).permit(:file, :key)
  end

end
