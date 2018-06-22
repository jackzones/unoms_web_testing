class UserPage
	include PageObject
	include MainHelper

	in_iframe(css: 'div[id="menu_user_tab_content"] iframe') do |iframe|
		table(:reload_icon, class: 'w2ui-button', index: 0, frame: iframe)
		table(:add_new_icon, class: 'w2ui-button', index: 3, frame: iframe)

		#add device form
		text_field(:username_form, id: 'username', frame: iframe)
		text_field(:password_form, id: 'password', frame: iframe)
		text_field(:retype_password_form, id: '__retype__password', frame: iframe)
		text_area(:oui_form, id: 'oui', frame: iframe)
		text_field(:email_form, id: 'email', frame: iframe)
		checkbox(:administrator_form, id: 'administrator', frame: iframe)
		button(:save_form, name: 'save', frame: iframe)
	end

	#click_a=>a_element.wait a_element.click ####抽象
	def self.click(name)
			define_method(name) do
					a = name.to_s.split('_')
					c = a.delete('click')
					b = a.join('_') + '_element'
					(self.send b.to_sym).wait_until_present
					(self.send b.to_sym).click
			end
	end

	click :click_add_new_icon
	click :click_reload_icon

	def add_admin(username, oui, password = '123456')
	  self.click_add_new_icon
		self.save_form_element.wait_until_present
		self.username_form = username
		self.password_form = password
		self.retype_password_form = password
		self.oui_form = oui
		self.email_form = self.gen_random_str(10) + '@163.com'
		self.check_administrator_form
		self.save_form
	end
end
