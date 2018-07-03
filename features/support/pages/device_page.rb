require_relative '../simulator/simtr'

class DevicePage
	include PageObject

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
		row_index = self.iframe(index: 1).div(id: 'grid_device_frecords').tr(text: /#{device_name}/).rowindex
		# Watir::Wait.until {self.iframe(index: 1).div(id: 'grid_device_records').table.td(id: "grid_device_data_#{row_index - 2}_12").div.text.include? '/'}
		status = self.iframe(index: 1).div(id: 'grid_device_records').table.td(id: "grid_device_data_#{row_index - 2}_11").span.attribute_value('class')
		status == "w2ui-icon-check" ? true : false
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

end
