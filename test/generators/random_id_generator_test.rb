require 'test_helper'

class RandomIdGeneratorTest < ActiveSupport::TestCase

  def test_successfully_generates_id_of_specific_length
    id = RandomIdGenerator.new.id(10)
    assert_equal id.length, 10
  end
end