class SettingsPage
	include PageObject

	in_iframe(css: 'div[id="menu_settings_tab_content"] iframe') do |iframe|
		button(:save_form, name: 'save', frame: iframe)
		checkbox(:auto_mount, id: 'auto_mount', frame: iframe)
	end

	def set_auto_mount(checked)
		self.save_form_element.wait_until_present
		checked == true ? check_auto_mount : uncheck_auto_mount
		self.save_form_element.click
	end
end
