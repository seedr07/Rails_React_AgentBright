require "test_helper"

class StatsHelperTest < ActionView::TestCase

  def test_stat_block
    stat_block = stat_block(value: 45, label: "Forecast Volume Full Year", columns: 4)
    assert stat_block.include?("Forecast Volume Full Year")
    assert stat_block.include?("col-sm-4")
    assert stat_block.include?("45")
  end

  def test_progress_bar_class
    assert_equal "success", progress_bar_class(100)
    assert_equal "danger", progress_bar_class(76)
    assert_equal nil, progress_bar_class(75)
  end

end
