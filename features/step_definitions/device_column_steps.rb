
Given /^用户root登录英文系统$/ do
	# visit_page(LoginPage)
	visit_page(LoginPage).login_with('en_us', 'root', '123456')
end


Given /^I click the SUBSCRIPTION$/ do
	on_page(HomePage).menu_subscription_element.wait_until_present.click
end

Given /^I click the Device$/ do
	on_page(HomePage).menu_device_element.wait_until_present.click
	on_page(DevicePage).reload_icon_element.wait_until_present
	on_page(DevicePage).click_reload_icon
end

# When /^click show_column_icon_element$/ do
# 	on_page(DevicePage).show_column_icon_element.wait_until_present
# 	on_page(DevicePage).show_column_icon_element.click
# end

When /^click the icon of show and hide column$/ do
	on_page(DevicePage).click_show_column_icon
end

When /^click the label of (.*)$/ do |click|
	on_page(DevicePage).send click.to_sym
	# binding.pry
end

Then /^the (.*) disapper$/ do |element|
	(on_page(DevicePage).send element.to_sym).exists?.should be_falsey

	# on_page(DevicePage).subscriber_name_column_element.present?.should be_falsey
end

Then /^the serial_number_column exists$/ do
	# sleep 2
	on_page(DevicePage).serial_number_column_element.present?.should be_truthy
end

Then /^the oui_column exists$/ do
	on_page(DevicePage).oui_column_element.present?.should be_truthy
	# binding.pry
end

When /^hover the mouse on the reload$/ do
	on_page(DevicePage).reload_icon_element.hover
end

Then /^show the text "([^\"]*)"$/ do |excepted|
	on_page(DevicePage).iframe_text.should include excepted
end

When /^hover the mouse on the (.*)$/ do |tool_menu|
	# on_page(DevicePage).tool_menu.to_s.hover
	(on_page(DevicePage).send tool_menu.to_sym).hover
end

Then /^I will see the (.*)$/ do |message|
	on_page(DevicePage).iframe_text.should include message
end
