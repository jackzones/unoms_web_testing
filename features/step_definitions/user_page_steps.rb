When /^添加OUI为'(.+)'的用户$/ do |oui|
	on_page(UserPage).add_admin('oui_form' => oui)
end
