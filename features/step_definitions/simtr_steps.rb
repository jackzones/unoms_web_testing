When /^让序列号为'(\d+)'的设备上线$/ do |serial_number|
	@simtr.device_register(serial_number)
end

When /^设备修改OUI为'(\d+)'$/ do |oui|
	@simtr.modify_oui(oui)
end

When /^修改URL为digest认证并且不带rkey，Username和password使用'(.*)'$/ do |username|
	@simtr.set_acs_info(@simtr.digest_url_without_rkey, username, username)
end
