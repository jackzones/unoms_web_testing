Feature: 诊断菜单里的RPC方法测试

	Background:
		Given 系统中存在一个设备

		@test
		Scenario: Reboot方法
			When 对此设备运行诊断菜单下的Reboot任务
			And 让序列号为'000000000100'的设备上线
			Then 设备Reboot成功


		# Background:
		# 	Given 用户root登录英文系统
		# 	And 导入TR系统license
		# 	And 用户root登录英文系统
		# 	And 进入Device界面
		# 	And 切换到Device界面
		#
		# 	@test
		# 	Scenario: 探测方式使设备上线
		# 		Then 名字为'auto_test1'的设备变为在线状态
