Given /^用户root登录英文系统$/ do
	# visit_page(LoginPage)
	visit_page(LoginPage).login_with('en_us', 'root', '123456')
end
