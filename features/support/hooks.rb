require 'watir'
require 'pry'
require_relative 'simulator/simtr'

Before do
  @browser = Watir::Browser.new :chrome
  @simtr = SimTR.new()
end


After do
  @browser.close
  @simtr.stop_simtr
end



# After( '@developing' ) do |scenario|
#   binding.pry if scenario.failed?
# end
