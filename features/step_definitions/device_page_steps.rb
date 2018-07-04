When /^click the icon of show and hide column$/ do
	on_page(DevicePage).click_show_column_icon
end

When /^click the label of (.+)$/ do |click|
	on_page(DevicePage).send click.to_sym
	# binding.pry
end

Then /^the (.+) disapper$/ do |element|
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

When /^hover the mouse on the (.+)$/ do |tool_menu|
	# on_page(DevicePage).tool_menu.to_s.hover
	(on_page(DevicePage).send tool_menu.to_sym).hover
end

Then /^I will see the (.+)$/ do |message|
	on_page(DevicePage).iframe_text.should include message
end

When /^添加一个设备，名字为'(.+)'，序列号为'(\d+)'，协议为'(\w+)'$/ do |device_name, serial_number, protocol|
	on_page(DevicePage).add_device(device_name, serial_number, protocol)
end

When /^点击设备界面的刷新按钮$/ do
	# sleep 1
	on_page(DevicePage).click_reload_icon
end

Then /^名字为'(.+)'的设备变为在线状态$/ do |device_name|
	on_page(DevicePage).online?(device_name).should be_truthy
	# binding.pry
end

When /^点击探测按钮，弹出探测窗口$/ do
	on_page(DevicePage).click_detect_icon
end

When /^点击http，digest认证$/ do
	on_page(DevicePage).digest_button
end

When /^复制URL，Username，Password到simulator，点击下一步，进入探测界面$/ do
	on_page(DevicePage).set_acs_info
	on_page(DevicePage).detect_next
end


Then /^探测到设备，编辑设备名为'(.+)'，点击保存按钮$/ do |sn|
	on_page(DevicePage).detect_add(sn)
	sleep 2
end

When /^对此设备运行诊断菜单下的Reboot任务$/ do
	# navigate_to(DevicePage).
end

Then /^设备Reboot成功$/ do
	on_page(DevicePage).reboot_success?.should be_truthy
end
