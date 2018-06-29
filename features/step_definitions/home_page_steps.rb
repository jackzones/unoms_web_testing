Given /^点击SUBSCRIPTION菜单$/ do
	on_page(HomePage).menu_subscription_element.wait_until_present.click
end

Given /^点击Device菜单$/ do
	on_page(HomePage).menu_device_element.wait_until_present.click
	on_page(DevicePage).reload_icon_element.wait_until_present
	on_page(DevicePage).click_reload_icon
end

When /^点击系统下的设置菜单$/ do
	on_page(HomePage).menu_settings_element.wait_until_present.click
end

When /^点击系统下的用户菜单$/ do
	on_page(HomePage).menu_user_element.wait_until_present.click
	on_page(UserPage).reload_icon_element.wait_until_present
	on_page(UserPage).click_reload_icon
end
