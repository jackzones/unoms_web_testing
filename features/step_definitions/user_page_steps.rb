When /^添加OUI为'(.*)'的管理员用户'(.*)'$/ do |oui, username|
	on_page(UserPage).add_admin(username, oui)
end
