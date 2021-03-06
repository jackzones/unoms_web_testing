require 'rspec'
require 'page-object'
require 'data_magic'
require 'require_all'
require 'mongo/document'
#
require_all File.dirname(__FILE__) + '/pages', \
File.dirname(__FILE__) + '/helper', File.dirname(__FILE__) + '/resource', \
File.dirname(__FILE__) + '/simulator', File.dirname(__FILE__) + '/model'

World(PageObject::PageFactory)

PageObject::PageFactory.routes = {
  :default => [
    [LoginPage, :login_with, 'en_us', 'root', '123456'],
    [HomePage, :goto_device_page],
    [DevicePage, :select_device]
  ]
}


# World(FactoryBot::Syntax::Methods)

if ENV['HEADLESS'] == 'true'
  require 'headless'
  headless = Headless.new
  headless.start
  at_exit do
    headless.destroy
  end
end
