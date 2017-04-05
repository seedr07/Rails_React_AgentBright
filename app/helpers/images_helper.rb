module ImagesHelper

  def display_fileinput_class(image)
    if image
      "fileinput-exists"
    else
      "fileinput-new"
    end
  end

end
