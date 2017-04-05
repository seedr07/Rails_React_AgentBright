class RandomIdGenerator

  def id(length)
    array1 = ("A".."Z").to_a
    array2 = ("a".."z").to_a
    array3 = ("0".."9").to_a
    combined_array = array1 + array2 + array3
    combined_array.shuffle.first(length).join
  end
end
