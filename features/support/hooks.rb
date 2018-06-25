require 'watir'
require 'pry'
require 'mongo'
require_relative 'simulator/simtr'
require_relative 'simulator/unoms'

Mongo::Logger.logger       = Logger.new('mongo.log')
Mongo::Logger.logger.level = Logger::INFO

Before do
  @unoms = UnoMS.new
  @unoms.stop
  Mongo::Client.new('mongodb://127.0.0.1:27017/unoms').database.drop
  # binding.pry
  system("mongo < './features/support/others/init.js'", :out => File::NULL)
  # binding.pry
  @unoms.start
  sleep 1
  @browser = Watir::Browser.new :chrome
  @simtr = SimTR.new()
  #登录系统，导入license
  visit_page(LoginPage)
  visit_page(LoginPage).login_with('en_us', 'root', '123456')
  on_page(LoginLicensePage).import_license_file(@simtr.license_file)
end

After do
  @browser.close
  @simtr.stop
end



# After( '@developing' ) do |scenario|
#   binding.pry if scenario.failed?
# end
