require 'watir'
require 'pry'
require 'mongo'
require_relative 'simulator/simtr'
require_relative 'simulator/unoms'
require_relative 'simulator/mongodb_database'

Mongo::Logger.logger       = Logger.new('mongo.log')
Mongo::Logger.logger.level = Logger::INFO

Before do
  # @unoms = UnoMS.new
  # @unoms.stop
  @db = MongodbDatabase.new
  # binding.pry
  @db.delete_collection_data
  # binding.pry
  # @unoms.start
  # sleep 1
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
