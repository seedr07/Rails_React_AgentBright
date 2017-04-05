require "test_helper"
require "leads_helper"

class Leads::StatsHelperTest < ActionView::TestCase

  include LeadsHelper

  fixtures :leads

  def setup
    @katie_lead = leads(:katie)
  end

end
