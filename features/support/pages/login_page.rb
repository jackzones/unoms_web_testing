class LoginPage
	include PageObject

	page_url 'http://192.168.13.54:8088/static/unoms.html#'

	text_field(:username, id: 'login_username')
	text_field(:password, id: 'login_password')
	link(:login, id: 'login')
	link(:zh_cn,id: 'zh-cn')
	link(:zh_tw, id: 'zh-tw')
	link(:en_us, id: 'en-us')

	def login_with(language, username, password)
		self.send language.to_sym
		self.username = username
		self.password = password
		login
	end
end
