Feature: 测试菜单里的RPC方法测试

	Background:
		Given 系统中存在一个设备

		@test
		Scenario: Reboot方法
			When 对此设备运行测试菜单下的Reboot任务
			And 让序列号为'000000000100'的设备上线
			Then 设备Reboot成功
