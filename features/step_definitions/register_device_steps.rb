
#some steps in the device_column_steps.rb
When /^添加一个设备，名字为'(.*)'，序列号为'(\d+)'，协议为'(\w+)'$/ do |device_name, serial_number, protocol|
	on_page(DevicePage).add_device(device_name, serial_number, protocol)
end

When /^让序列号为'(\d+)'的设备上线$/ do |serial_number|
	@simtr.device_register(serial_number)
end

When /^点击设备界面的刷新按钮$/ do
	sleep 1
	on_page(DevicePage).click_reload_icon
end

Then /^名字为'(.*)'的设备变为在线状态$/ do |device_name|
	on_page(DevicePage).online?(device_name).should be_truthy
	# binding.pry
end

When /^点击探测按钮，弹出探测窗口$/ do
	on_page(DevicePage).click_detect_icon
end

When /^点击http，digest认证$/ do
	on_page(DevicePage).digest_button
end

When /^复制URL，Username，Password到simulator$/ do
	on_page(DevicePage).set_acs_info
end

When /^点击下一步，进入探测界面$/ do
	on_page(DevicePage).detect_next
end

Then /^探测到设备，编辑设备名为'(.*)'，点击保存按钮$/ do |sn|
	on_page(DevicePage).detect_add(sn)
end

When /^点击系统下的设置菜单$/ do
	on_page(HomePage).menu_settings_element.wait_until_present.click
end

When /^开启Auto Mount功能$/ do
	on_page(SettingsPage).set_auto_mount(true)
	# binding.pry
end

When /^点击系统下的用户菜单$/ do
	on_page(HomePage).menu_user_element.wait_until_present.click
	on_page(UserPage).reload_icon_element.wait_until_present
	on_page(UserPage).click_reload_icon
end

When /^添加OUI为'(.*)'的管理员用户'(.*)'$/ do |oui, username|
	on_page(UserPage).add_admin(username, oui)
end

When /^设备修改OUI为'(\d+)'$/ do |oui|
	@simtr.modify_oui(oui)
end

When /^修改URL为digest认证并且不带rkey，Username和password使用'(.*)'$/ do |username|
	@simtr.set_acs_info(@simtr.digest_url_without_rkey, username, username)
end

# Given /^导入TR系统license$/ do
# 	on_page(LoginLicensePage).import_license_file(@simtr.license_file)
# end
