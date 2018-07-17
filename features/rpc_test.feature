Feature: 测试菜单里的RPC方法测试

	Background:
		Given 系统中存在一个设备

	Scenario: Reboot方法
		When 对此设备运行测试菜单下的Reboot任务
		And 让序列号为'000000000100'的设备上线
		Then 设备Reboot成功

	# @test
	# Scenario: GPN(param=full path, nl=false) 返回参数本身
	# 	When 对设备运行测试菜单下的GetParameterNames任务，参数为'Device.DeviceInfo.ManufacturerOUI'，NextLevel为'false'
	# 	And 让序列号为'000000000100'的设备上线
	# 	Then RPC返回结果包含'Name:Device.DeviceInfo.ManufacturerOUIWritable:false'

	@test
	Scenario Outline: RPC测试，GetParameterNames测试，结果为包含。
		When 对设备运行测试菜单下的GetParameterNames任务，参数为'<parameter>'，NextLevel为'<next_level>'
		And 让序列号为'000000000100'的设备上线
		Then RPC返回结果包含'<result_message>'

		Examples:
			| parameter | next_level | result_message |
			| Device.DeviceInfo.ManufacturerOUI | true | 9003 |
			| empty | false | Name:Device.DeviceInfo.ManufacturerOUIWritable:false, Name:Device.ManagementServer.PeriodicInformEnableWritable:true |
			| Device.SoftwareModules.ExecEnv. | false | Name:Device.SoftwareModules.ExecEnv.1.Writable:false, Name:Device.SoftwareModules.ExecEnv.Writable:false, Name:Device.SoftwareModules.ExecEnv.1.NameWritable:false |


	@test
	Scenario Outline: RPC测试，GetParameterNames测试，结果为只含有。
		When 对设备运行测试菜单下的GetParameterNames任务，参数为'<parameter>'，NextLevel为'<next_level>'
		And 让序列号为'000000000100'的设备上线
		Then RPC返回结果只有'<result_message>'

		Examples:
			| parameter | next_level | result_message |
			| Device.DeviceInfo.ManufacturerOUI | false | Name:Device.DeviceInfo.ManufacturerOUIWritable:false |
			| empty | true | Name:Device.Writable:false |
			| Device.DeviceInfo.Ma | true | FaultCode:9005FaultString:Invalid Parameter name |
			| Device.SoftwareModules.ExecEnv. | true | Name:Device.SoftwareModules.ExecEnv.1.Writable:false |
			| Device.SoftwareModules.DeploymentUnit. | true | Success |
