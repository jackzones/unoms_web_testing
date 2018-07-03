Feature: Device Column


Background:
	Given 用户root登录英文系统
	And 进入Device界面
	And 切换到Device界面


	Scenario: the existence of the device column

	    # Then the subscriber_name_column disapper
	    Then the serial_number_column exists
	    And the oui_column exists



	Scenario Outline: the mouse hover the tool menu will show message
	    When hover the mouse on the <tool_menu>
	    Then I will see the <message>

	    Examples:
	    |tool_menu 		 	 		|message 	 	 		|
	    |reload_icon_element 		|Reload data in the list|
	    |show_column_icon_element 	|Show/hide columns  	|
	    |search_icon_element		|Open Search Fields 	|
	    |add_new_icon_element 		|Add new record	 	 	|
	    |detect_icon_element 		|Detect and add device  |


	Scenario Outline: hide the label of column
	    When click the icon of show and hide column
	    And click the label of <click_label>
	    Then the <label_element> disapper

	    Examples:
	    |click_label	 	 	 	 	|label_element|
	    |click_show_subscriber_name	 	|subscriber_name_column_element|
	    |click_show_subscriber_id 		|subscriber_id_column_element|
