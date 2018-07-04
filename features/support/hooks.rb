require 'watir'
require 'pry'
require 'mongo'
require_relative 'simulator/simtr'
require 'mongo/document'
# require_relative 'simulator/unoms'
# require_relative 'simulator/mongodb_database'

Mongo::Logger.logger       = Logger.new('mongo.log')
Mongo::Logger.logger.level = Logger::INFO

Before do
  #清空数据库的数据，不需要重新导入license
  client = Mongo::Client.new('mongodb://127.0.0.1:27017/unoms')
  except_collection = ['license', 'script', 'permission', 'user', 'grid_state', 'settings']
  client.collections.delete_if{|i| except_collection.include?(i.name)}.each {|i| i.delete_many}
  client[:script].delete_many("built_in" => {"$ne" => true})
  client[:user].delete_many("username" => {"$ne" => "root"})
  client[:settings].update_one({"smtp_port" => 465}, "$set" => {"auto_mount" => false})

  @browser = Watir::Browser.new :chrome
  @simtr = SimTR.new()
  #登录系统，导入license
  # visit_page(LoginPage)
  # visit_page(LoginPage).login_with('en_us', 'root', '123456')
  # on_page(LoginLicensePage).import_license_file(@simtr.license_file)
#   Mongo::Document.establish_connection(
#   :hosts => ["localhost:27017"],
#   :database => "unoms",
# )
end

After do |scenario|
  if scenario.respond_to?('scenario_outline') then
      scenario = scenario.scenario_outline
  end
  if scenario.failed?
     filename = "error_#{@current_page.class}_#{Time.now.strftime("%Y%m%d_%H%M%S")}.png"
     @current_page.save_screenshot("screenshots/#{filename}")
     embed("screenshots/#{filename}", 'image/png')
  end
  @browser.close
  @simtr.stop
end
#
# After do |s|
#   # Tell Cucumber to quit after this scenario is done - if it failed.
#   Cucumber.wants_to_quit = true if s.failed?
# end
