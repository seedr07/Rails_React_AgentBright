require "test_helper"

class FieldSanitizers::FieldCleanerTest < ActiveSupport::TestCase

  test "should sanitize cleanable fields" do
    cleaned_params = FieldSanitizers::FieldCleaner.new(params: dirty_params, cleanable_fields: cleanable_fields).scrub
    assert_equal "13342343", cleaned_params[:cleanable_param1]
    assert_equal "1000", cleaned_params[:cleanable_param2]
    assert_equal "4000000", cleaned_params[:cleanable_param3]
    assert_equal "String", cleaned_params[:uncleanable_param1]
    assert_equal(
      "Longer string with some, shall we say, commas.",
      cleaned_params[:uncleanable_param2]
    )
    assert_equal "55,000,000", cleaned_params[:uncleanable_param3]
  end

  test "should sanitize property fields" do
    cleaned_params = FieldSanitizers::FieldCleaner.new(params: dirty_params).scrub_property_fields
    assert_equal "555555555", cleaned_params[:original_list_price]
    assert_equal "13,342,343", cleaned_params[:cleanable_param1]
  end

  private

  def dirty_params
    {
      cleanable_param1: "13,342,343",
      cleanable_param2: "1,000",
      cleanable_param3: "4,000,000",
      uncleanable_param1: "String",
      uncleanable_param2: "Longer string with some, shall we say, commas.",
      uncleanable_param3: "55,000,000",
      original_list_price: "555,555,555"
    }
  end

  def cleanable_fields
    [:cleanable_param1, :cleanable_param2, :cleanable_param3]
  end

end
