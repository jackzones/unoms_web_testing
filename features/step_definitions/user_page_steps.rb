When /^添加OUI为'(.+)'的管理员用户$/ do |oui|
	on_page(UserPage).add_admin('oui' => oui)
end
