require 'test_helper'

class ImagesControllerTest < ActionController::TestCase
  include ActionDispatch::TestProcess

  def setup
    @user = users(:nancy)
    @user.images.destroy_all

    @uploaded_file = fixture_file_upload(Rails.root.join("/images/test.png"), "image/png")

    sign_in @user
  end

  def test_create_for_normal_image
    post :create, xhr: true, params: { image: { file:  @uploaded_file }, multipart: true }

    assert_equal 1, @user.images.count
  end

  def test_create_for_profile_image
    post(
      :create,
      xhr: true,
      params: {
        image: { file: @uploaded_file },
        multipart: true,
        from_profile_edit_page: "true"
      }
    )
    assert @user.profile_image
  end
end
