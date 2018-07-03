require 'rspec'
require 'page-object'
require 'data_magic'

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
