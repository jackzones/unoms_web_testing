require 'rspec'
require 'page-object'
require 'data_magic'
require 'require_all'

require_all File.dirname(__FILE__) + '/pages'
PageObject::PageFactory.routes = {
  :default => [
    [LoginPage, :login_with],
    [HomePage, :goto_device_page],
    [DevicePage, :online?]
  ]
}

World(PageObject::PageFactory)
# World(FactoryBot::Syntax::Methods)

if ENV['HEADLESS'] == 'true'
  require 'headless'
  headless = Headless.new
  headless.start
  at_exit do
    headless.destroy
  end
end
