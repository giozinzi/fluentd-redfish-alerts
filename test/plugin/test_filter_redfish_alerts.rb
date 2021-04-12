require "helper"
require "fluent/plugin/filter_redfish_alerts.rb"

class RedfishAlertsFilterTest < Test::Unit::TestCase
  setup do
    Fluent::Test.setup
  end

  test "failure" do
    flunk
  end

  private

  def create_driver(conf)
    Fluent::Test::Driver::Filter.new(Fluent::Plugin::RedfishAlertsFilter).configure(conf)
  end
end
