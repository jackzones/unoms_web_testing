class HomePage
	include PageObject
	##main menu
	div(:menu_subscription, id: 'node_menu_subscription_group')
	div(:menu_administration, id: 'node_menu_administration')
	div(:menu_system, id: 'node_menu_system')

	##sub menu

	###Subscription
	div(:menu_device, id: 'node_menu_device')
	div(:menu_subscriber, id: 'node_menu_subscription')
	div(:menu_order, id: 'node_menu_order')
	div(:menu_status, id: 'node_menu_subscription')
	div(:menu_backup, id: 'node_menu_backup')
	div(:menu_device_log, id: 'node_menu_device_log')

	###Administration
	div(:menu_tag, id: 'node_menu_tag')
	div(:menu_firmware, id: 'node_menu_firmware')
	div(:menu_script, id: 'node_menu_script')
	div(:menu_event, id: 'node_menu_event')
	div(:menu_service, id: 'node_menu_service')
	div(:menu_scheduler, id: 'node_menu_scheduler')
	div(:menu_action, id: 'node_menu_action')

	###System
	div(:menu_domain, id: 'node_menu_domain')
	div(:menu_user, id: 'node_menu_user')
	div(:menu_role, id: 'node_menu_role')
	div(:menu_license, id: 'node_menu_license')
	div(:menu_log, id: 'node_menu_log')
	div(:menu_settings, id: 'node_menu_settings')
	div(:menu_dashboard, id: 'node_menu_dashboard')

	def goto_device_page
		menu_subscription_element.wait_until_present.click
		menu_device_element.wait_until_present.click
	end

end
