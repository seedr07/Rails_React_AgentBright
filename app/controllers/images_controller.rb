class ImagesController < ApplicationController

  def create
    if params[:from_profile_edit_page] == "true"
      @image = set_profile_image
    else
      @image = current_user.images.new(upload_params)
    end

    if @image.valid_image_size? upload_params[:file]
      begin
        @image.set_dimensions(upload_params[:file])
        @image.save
      rescue Exception => e
        Util.log "ERROR WHILE SAVING IMAGE => #{e.message}"
      end
    end
    set_error_in_flash unless @image.persisted?

    if request.xhr?
      if @image.errors.present?
        render json: @image.to_json(methods: :errors)
      else
        render json: @image.to_json(methods: :file), location: request.referer
      end
    else
      redirect_to request.referer
    end
  end

  protected

  def upload_params
    params.require(:image).permit(:file, :remote_file_url)
  end

  def set_error_in_flash
    flash.now[:error] = @image.errors.full_messages.join(". ")
  end

  def set_profile_image
    if current_user.profile_image.present?
      profile_image = current_user.profile_image
      profile_image.file = upload_params[:file]
      profile_image
    else
      current_user.build_profile_image(upload_params)
    end
  end

end
