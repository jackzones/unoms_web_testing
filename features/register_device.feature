Feature: 设备注册

# Background:
# 	Given 用户root登录英文系统
# 	And I click the SUBSCRIPTION
# 	And I click the Device

	#
	# Scenario: 手动添加设备，设备注册
	# 	When 添加一个设备，名字为'auto_test0'，序列号为'000000000100'，协议为'CWMP'
	# 	And 让序列号为'000000000100'的设备上线
	# 	And 点击设备界面的刷新按钮
	# 	Then 名字为'auto_test1'的设备变为在线状态
	#
	# Scenario: 探测方式使设备上线
	# 	When 点击探测按钮，弹出探测窗口
	# 	And 点击http，digest认证
	# 	And 复制URL，Username，Password到simulator
	# 	And 点击下一步，进入探测界面
	# 	And 让序列号为'000000000101'的设备上线
	# 	Then 探测到设备，编辑设备名为'auto_test1'，点击保存按钮
	# 	And 点击设备界面的刷新按钮
	# 	Then 名字为'auto_test1'的设备变为在线状态
	#
	#
	# Scenario: Auto mount方式设备注册
	# 	When 点击系统下的设置菜单
	# 	And 开启Auto Mount功能
	# 	And 点击系统下的用户菜单
	# 	And 添加OUI为'123457'的管理员用户'auto_123457'
	# 	And 设备修改OUI为'123457'
	# 	And 修改URL为digest认证并且不带rkey，Username和password使用'unoms'
	# 	And 让序列号为'000000000102'的设备上线
	# 	And I click the Device
	# 	Then 名字为'123457-000000000102'的设备变为在线状态

	Background:
		Given 用户root登录英文系统
		And 导入TR系统license
		And 用户root登录英文系统
		And I click the SUBSCRIPTION
		And I click the Device

		@test
		Scenario: 探测方式使设备上线
			Then 名字为'auto_test1'的设备变为在线状态
