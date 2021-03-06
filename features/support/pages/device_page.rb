require_relative '../simulator/simtr'

class DevicePage
	include PageObject
	include MainHelper

	in_iframe(css: 'div[id="menu_device_tab_content"] iframe') do |iframe|
		# text_field(:address, id: 'address_id', frame: frame)
		device_column = { subscriber_name_column: 'grid_device_column_1',
							subscriber_id_column: 'grid_device_column_2',
							serial_number_column: 'grid_device_column_3',
							oui_column: 'grid_device_column_4',
							product_class_column: 'grid_device_column_5',
							manufacturer_column: 'grid_device_column_6',
							model_column: 'grid_device_column_7',
							ip_address_column: 'grid_device_column_8',
							mac_address_column: 'grid_device_column_9',
							last_on_line_time_column: 'grid_device_column_10',
							firmware_version_column: 'grid_device_column_11',
							no_of_inform_column: 'grid_device_column_12',
							domain_column: 'grid_device_column_13',
							tags_column: 'grid_device_column_14'
						}
		device_column.each do |key, value|
			cell(key, :id => value, frame: iframe)
		end
		#icon of the devicepage
		table(:reload_icon, class: 'w2ui-button', index: 0, frame: iframe)
		table(:show_column_icon, class: 'w2ui-button', index: 1, frame: iframe)
		table(:search_icon, class: 'w2ui-button', index: 2, frame: iframe)
		table(:add_new_icon, class: 'w2ui-button', index: 3, frame: iframe)
		table(:detect_icon, class: 'w2ui-button', index: 6, frame: iframe)
		#the label of the show_column_icon
		label(:show_subscriber_name, text: 'Subscriber Name', frame: iframe)
		label(:show_subscriber_id, text: 'Subscriber ID', frame: iframe)

		#add device form
		text_field(:name_form, id: 'name', frame: iframe)
		text_field(:serial_number_form, id: 'serial_number', frame: iframe)
		text_field(:protocol_form, id: 'protocol', frame: iframe)
		button(:save_form, name: 'save', frame: iframe)

		#combo dropdown list
		table(:drop_down_form, class: 'w2ui-drop-menu', frame: iframe)

		#device list table
		table(:device_list_1, id: 'grid_device_frecords', frame: iframe)
		table(:device_list_2, class: 'grid_device_records', frame: iframe)

		#detect
		button(:no_auth_button, id: 'HttpWithoutAuth', frame: iframe)
		button(:basic_button, id: 'HttpWithBasicAuth', frame: iframe)
		button(:digest_button, id: 'HttpWithDigest', frame: iframe)
		button(:detect_next, id: 'dectect_device_next_btn', frame: iframe)
		text_area(:detect_url, id: 'url', frame: iframe)
		text_field(:detect_username, id: 'username', frame: iframe)
		text_field(:detect_password, id: 'password', frame: iframe)
		text_field(:detect_device_name, id: 'name', frame: iframe)
		text_field(:detect_subscriber_id, id: 'subscriber_id', frame: iframe)

		div(:page_footer, class: 'w2ui-footer-right', frame: iframe)

		#toolbar
		div(:toolbar_icon, class: 'w2ui-flat-right', frame: iframe)
		#toolbar-diagnostics
		div(:diagnostic_reboot, id: 'node_Reboot', frame: iframe)
		button(:run, class: 'w2ui-btn', name: 'run', frame: iframe)

		#toolbar-test
		div(:test_reboot, id: 'node_Test_Reboot', frame: iframe)
		div(:test_gpn, id: 'node_Test_GetParameterNames', frame: iframe)
		div(:test_gpv, id: 'node_Test_GetParameterValues', frame: iframe)
		div(:test_gpa, id: 'node_Test_GetParameterAttributes', frame: iframe)
		div(:test_spv, id: 'node_Test_SetParameterValues', frame: iframe)
		#reboot
		div(:reboot_msg, id: 'resultMsg', frame: iframe)

		#toolbar form
		label(:parameter_label, text: 'Parameter', frame: iframe)
		text_field(:parameter_form, id: 'Parameter', frame: iframe)
		text_field(:parameters_form, id: 'Parameters', frame: iframe)
		checkbox(:next_level_form, id: 'NextLevel', frame: iframe)
		div(:result_form, class: %w(w2ui-page page-0), frame: iframe)
		button(:add_item, id: 'Parameters_btn_add', frame: iframe)
		button(:close_item, id: 'Parameters_btn_close', frame: iframe)
		text_field(:name_item, id: 'Name_input', frame: iframe)
		span(:name_label, class: 'drop-list-name', frame: iframe)
		text_field(:param_key_form, id: 'ParameterKey', frame: iframe)
		text_field(:type_form, id: 'Type_input', frame: iframe)
		text_field(:value_form, id: 'Value_input', frame: iframe)

		div(:type_drop, id: 'Type_drop', frame: iframe)

		#9 method for the drop list
		type_drop_list = {
			type_string: 0,
			type_int: 1,
			type_unsigned_int: 2,
			type_long: 3,
			type_unsigned_long: 4,
			type_boolean: 5,
			type_date_time: 6,
			type_base64: 7,
			type_hex_binary: 8
		}

		#nested div/paragraph
		type_drop_list.each do |key, value|
			paragraph(key, frame: iframe) do |page|
				page.type_drop_element.paragraph_elements[value]
			end
		end

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

  ##click the icon of devicepage
  click :click_show_column_icon
  click :click_search_icon
  click :click_reload_icon
  click :click_add_new_icon
  click :click_detect_icon

  ##click the label of the show_column_icon
  click :click_show_subscriber_name
  click :click_show_subscriber_id

	click :click_parameter_label

	def iframe_text
		self.iframe(index: 1).text
	end

	def add_device(device_name, serial_number, protocol)
	  click_add_new_icon
		save_form_element.wait_until_present
		self.name_form = device_name
		self.serial_number_form = serial_number
		self.protocol_form = protocol
		drop_down_form_element[protocol].click
		save_form
	end

	#device list 分两个table，找到第一个表row_index和第二个表td的class的关系，减2
	def online?(device_name)
		row_index = self.iframe(css: 'div[id="menu_device_tab_content"] iframe').div(id: 'grid_device_frecords').tr(text: /#{device_name}/).rowindex
		# Watir::Wait.until {self.iframe(index: 1).div(id: 'grid_device_records').table.td(id: "grid_device_data_#{row_index - 2}_12").div.text.include? '/'}
		status = self.iframe(css: 'div[id="menu_device_tab_content"] iframe').div(id: 'grid_device_records').table.td(id: "grid_device_data_#{row_index - 2}_11").span.attribute_value('class')
		status == "w2ui-icon-check" ? true : false
	end

	def select_device(device_name)
		row_index = self.iframe(css: 'div[id="menu_device_tab_content"] iframe').div(id: 'grid_device_frecords').tr(text: /#{device_name}/).rowindex
		# Watir::Wait.until {self.iframe(index: 1).div(id: 'grid_device_records').table.td(id: "grid_device_data_#{row_index - 2}_12").div.text.include? '/'}
		self.iframe(css: 'div[id="menu_device_tab_content"] iframe').div(id: 'grid_device_records').table.td(id: "grid_device_data_#{row_index - 2}_11").span.click

	end

	def set_acs_info
		detect_next_element.wait_until_present
		url = self.detect_url
		username = self.detect_username
		password = self.detect_password
		SimTR.new().set_acs_info(url, username, password)
	end

	def detect_add(sn, s_id= '')
		save_form_element.wait_until_present
		self.detect_device_name = sn
		self.detect_subscriber_id = s_id
		save_form
	end

	def reboot_success?
		reboot_msg_element.wait_until_present
		reboot_msg.match(/Reboot time:\s\d+\sseconds/) ? true : false
	end

	def expand_toolbar
	  toolbar_icon_element.click if toolbar_icon_element.visible?
	end

	def run_diag_reboot
		expand_toolbar
		diagnostic_reboot_element.wait_until_present.click
		run
	end

	def run_test_reboot
		expand_toolbar
		test_reboot_element.wait_until_present.click
		run
	end

	def run_test_gpn(next_level, param)
		expand_toolbar
		test_gpn_element.wait_until_present.click
		unless param == 'empty'
			self.parameter_form = param
			drop_down_form_element[param] == nil ? click_parameter_label : drop_down_form_element[param].click
		end
		next_level == 'true' ? check_next_level_form : uncheck_next_level_form
		run
	end

	def result
	  result_form.tr("\n", "").strip
	end

	def run_test_gpv(param)
		expand_toolbar
		test_gpv_element.wait_until_present.click
		get_parameters(param)
	end

	def run_test_gpa(param)
		expand_toolbar
		test_gpa_element.wait_until_present.click
		get_parameters(param)
	end

	def run_test_spv(param, param_key)
	  expand_toolbar
		test_spv_element.wait_until_present.click
		parameters_form_element.wait_until_present.click
		param_key_form = param_key unless param_key == 'empty'
		set_parameters(param)
	end

	private

	def get_parameters(param)
		parameters_form_element.wait_until_present.click
		names = MainHelper.to_array_by_comma(param)
		names.each do |name|
			if name == 'empty'
				add_item
			else
				self.name_item = name
				name_label_element.click
				add_item
			end
		end
		close_item
		run
	end

	def set_parameters(param)
		element = MainHelper.to_array_by_semicolon(param)
		element.each do |item|
				self.name_item = item[0]
				name_label_element.click
				type_drop_select(item[1])
				self.value_form = item[2]
				add_item
		end
		close_item
		run
	end

	def type_drop_select(type)
		type_form_element.click
		case type
		when 'string'
			type_string_element.click
		when 'int'
			type_int_element.click
		when 'unsignedInt'
			type_unsigned_int_element.click
		when 'long'
			type_long_element.click
		when 'unsignedLong'
			type_unsigned_long_element.click
		when 'boolean'
			type_boolean_element.click
		when 'dateTime'
			type_date_time_element.click
		when 'base64'
			type_base64_element.click
		when 'hexBinary'
			type_hex_binary_element.click 
		end
	end

end
