# == Schema Information
#
# Table name: images
#
#  attachable_id   :integer
#  attachable_type :string
#  created_at      :datetime
#  file            :string
#  height          :integer
#  id              :integer          not null, primary key
#  updated_at      :datetime
#  user_id         :integer
#  width           :integer
#
# Indexes
#
#  index_images_on_attachable_type_and_attachable_id  (attachable_type,attachable_id)
#  index_images_on_user_id                            (user_id)
#

class Image < ActiveRecord::Base

  belongs_to :owner, polymorphic: true
  belongs_to :attachable, polymorphic: true

  mount_uploader :file, ImageUploader

  def valid_image_size?(image_file)
    if image = open_minimagick_image(image_file)
      if image[:width] < 180 && image[:height] < 180
        errors.add :file, "File should be minimum 180px x 180px!"
        false
      else
        true
      end
    end
  end

  def image_url
    file.url if file.present?
  end

  def attachable_class
    if attachable_type == "Property"
      "image_is_property_image"
    end
  end

  def set_dimensions(image_file)
    if image = open_minimagick_image(image_file)
      self.height = image[:height]
      self.width = image[:width]
    end
  end

  private

  def open_minimagick_image(image_file)
    begin
      if image_file.path
        MiniMagick::Image.open(image_file.path)
      else
        MiniMagick::Image.open(image_file)
      end
    rescue
      MiniMagick::Image.open(image_file)
    end
  rescue MiniMagick::Invalid
    return false
  end

end
