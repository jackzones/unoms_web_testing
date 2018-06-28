require 'watir'
require 'pry'
require 'mongo'
require_relative 'simulator/simtr'
require_relative 'simulator/unoms'
# require_relative 'simulator/mongodb_database'

Mongo::Logger.logger       = Logger.new('mongo.log')
Mongo::Logger.logger.level = Logger::INFO

Before do
  # @unoms = UnoMS.new
  # @unoms.stop
  client = Mongo::Client.new('mongodb://127.0.0.1:27017/unoms')
  except_collection = ['license', 'script', 'permission', 'user', 'grid_state', 'settings']
  client.collections.delete_if{|i| except_collection.include?(i.name)}.each {|i| i.delete_many}
  client[:script].delete_many("built_in" => {"$ne" => true})
  client[:user].delete_many("username" => {"$ne" => "root"})
  client[:settings].update_one({"smtp_port" => 465}, "$set" => {"auto_mount" => false})
  # binding.pry
  # system("mongo < './features/support/others/init.js'", :out => File::NULL)
  # client.collections.delete_if{|i| i.name == 'license'}.each {|i| i.delete_many}
  # binding.pry
  # @unoms.start
  # sleep 1
  @browser = Watir::Browser.new :chrome
  @simtr = SimTR.new()
  #登录系统，导入license
  # visit_page(LoginPage)
  # visit_page(LoginPage).login_with('en_us', 'root', '123456')
  # on_page(LoginLicensePage).import_license_file(@simtr.license_file)
end

After do
  @browser.close
  @simtr.stop
end



# After( '@developing' ) do |scenario|
#   binding.pry if scenario.failed?
# end
