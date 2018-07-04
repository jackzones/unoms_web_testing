require 'rspec'
require 'page-object'
require 'data_magic'
require 'require_all'

require_all File.dirname(__FILE__) + '/'

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
