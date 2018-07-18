Feature: 测试菜单里的RPC方法测试

	Background:
		Given 系统中存在一个设备

	Scenario: Reboot方法
		When 对此设备运行测试菜单下的Reboot任务
		And 让序列号为'000000000100'的设备上线
		Then 设备Reboot成功


	Scenario Outline: RPC测试，GetParameterNames测试，结果为包含。
		When 对设备运行测试菜单下的GetParameterNames任务，参数为'<parameter>'，NextLevel为'<next_level>'
		And 让序列号为'000000000100'的设备上线
		Then RPC返回结果包含'<result_message>'

		Examples:
			| parameter | next_level | result_message |
			| empty | false | Name:Device.DeviceInfo.ManufacturerOUIWritable:false, Name:Device.ManagementServer.PeriodicInformEnableWritable:true |
			| Device.SoftwareModules.ExecEnv. | false | Name:Device.SoftwareModules.ExecEnv.1.Writable:false, Name:Device.SoftwareModules.ExecEnv.Writable:false, Name:Device.SoftwareModules.ExecEnv.1.NameWritable:false |


	Scenario Outline: RPC测试，GetParameterNames测试，结果为只含有。
		When 对设备运行测试菜单下的GetParameterNames任务，参数为'<parameter>'，NextLevel为'<next_level>'
		And 让序列号为'000000000100'的设备上线
		Then RPC返回结果只有'<result_message>'

		Examples:
			| parameter | next_level | result_message |
			| Device.DeviceInfo.ManufacturerOUI | false | Name:Device.DeviceInfo.ManufacturerOUIWritable:false |
			| empty | true | Name:Device.Writable:false |
			| Device.DeviceInfo.Ma | true | FaultCode:9005FaultString:Invalid parameter name |
			| Device.SoftwareModules.ExecEnv. | true | Name:Device.SoftwareModules.ExecEnv.1.Writable:false |
			| Device.SoftwareModules.DeploymentUnit. | true | Success |
			| Device.DeviceInfo.ManufacturerOUI | true | FaultCode:9003FaultString:Invalid arguments |


	Scenario Outline: RPC测试，GetParameterValues测试，结果为包含。
		When 对设备运行测试菜单下的GetParameterValues任务，参数为'<parameter>'
		And 让序列号为'000000000100'的设备上线
		Then RPC返回结果包含'<result_message>'

		Examples:
			| parameter | result_message |
			| Device.DeviceInfo. | Name:Device.DeviceInfo.ModelNameType:stringValue:, Name:Device.DeviceInfo.ProductClassType:stringValue: |
			| Device.DeviceInfo.ModelName | Name:Device.DeviceInfo.ModelNameType:stringValue: |
			| Device.DeviceInfo.ModelName, Device.DeviceInfo.ProductClass | Name:Device.DeviceInfo.ModelNameType:stringValue:, Name:Device.DeviceInfo.ProductClassType:stringValue: |
			| empty | Device.DeviceInfo.ModelName, Device.ManagementServer.Username, Device.SoftwareModules.DeploymentUnitNumberOfEntries, Device.LAN.IPAddress |
			| Device.DeviceInfo.ModelName, Device.DeviceInfo.ModelName | Name:Device.DeviceInfo.ModelNameType:stringValue: |


	Scenario Outline: RPC测试，GetParameterValues测试，结果为只含有。
		When 对设备运行测试菜单下的GetParameterValues任务，参数为'<parameter>'
		And 让序列号为'000000000100'的设备上线
		Then RPC返回结果只有'<result_message>'

		Examples:
			| parameter | result_message |
			| Device.Error. | FaultCode:9005FaultString:Invalid parameter name |
			| Device.Error | FaultCode:9005FaultString:Invalid parameter name |
			| Device.DeviceInfo.ModelName, Device.DeviceInfo.Error | FaultCode:9005FaultString:Invalid parameter name |
			| Device.SoftwareModules.DeploymentUnit. | Success |
			| Device.ManagementServer.Password | Name:Device.ManagementServer.PasswordType:stringValue: |


	Scenario Outline: RPC测试，GetParameterAttributes测试，结果为包含。
		When 对设备运行测试菜单下的GetParameterAttributes任务，参数为'<parameter>'
		And 让序列号为'000000000100'的设备上线
		Then RPC返回结果包含'<result_message>'

		Examples:
			| parameter | result_message |
			| Device.DeviceInfo. | AccessList:Name:Device.DeviceInfo.ModelNameNotification:, AccessList:Name:Device.DeviceInfo.ProductClassNotification: |
			| Device.DeviceInfo.ModelName | AccessList:Name:Device.DeviceInfo.ModelNameNotification: |
			| Device.DeviceInfo.ModelName, Device.DeviceInfo.ProductClass | AccessList:Name:Device.DeviceInfo.ModelNameNotification:, AccessList:Name:Device.DeviceInfo.ProductClassNotification: |
			| empty | Device.DeviceInfo.ModelName, Device.ManagementServer.Username, Device.SoftwareModules.DeploymentUnitNumberOfEntries, Device.LAN.IPAddress |
			| Device.DeviceInfo.ModelName, Device.DeviceInfo.ModelName | AccessList:Name:Device.DeviceInfo.ModelNameNotification: |

	Scenario Outline: RPC测试，GetParameterAttributes测试，结果为只含有。
		When 对设备运行测试菜单下的GetParameterAttributes任务，参数为'<parameter>'
		And 让序列号为'000000000100'的设备上线
		Then RPC返回结果只有'<result_message>'

		Examples:
			| parameter | result_message |
			| Device.Error. | FaultCode:9005FaultString:Invalid parameter name |
			| Device.Error | FaultCode:9005FaultString:Invalid parameter name |
			| Device.SoftwareModules.DeploymentUnit. | Success |
			| Device.DeviceInfo.ModelName, Device.Error | FaultCode:9005FaultString:Invalid parameter name |

	@test
	Scenario Outline: RPC测试，SetParameterValues测试，结果为包含。
		When 对设备运行测试菜单下的SetParameterValues任务，参数为'<parameter>'，ParameterKey为'<key>'
		And 让序列号为'000000000100'的设备上线
		Then RPC返回结果包含'<result_message>'

		Examples:
			| parameter | key |result_message |
			| Device.DeviceInfo.ProvisioningCode:string:22 | empty | Status: |
			| Device.DeviceInfo.ProvisioningCode:string:22, Device.ManagementServer.PeriodicInformInterval:unsignedInt:20 | empty | Status: |
	# 		| Device.DeviceInfo.ModelName | Name:Device.DeviceInfo.ModelNameType:stringValue: |
	# 		| Device.DeviceInfo.ModelName, Device.DeviceInfo.ProductClass | Name:Device.DeviceInfo.ModelNameType:stringValue:, Name:Device.DeviceInfo.ProductClassType:stringValue: |
	# 		| empty | Device.DeviceInfo.ModelName, Device.ManagementServer.Username, Device.SoftwareModules.DeploymentUnitNumberOfEntries, Device.LAN.IPAddress |
	# 		| Device.DeviceInfo.ModelName, Device.DeviceInfo.ModelName | Name:Device.DeviceInfo.ModelNameType:stringValue: |
	#
	# # @test
	# Scenario Outline: RPC测试，SetParameterValues测试，结果为只含有。
	# 	When 对设备运行测试菜单下的SetParameterValues任务，参数为'<parameter>'
	# 	And 让序列号为'000000000100'的设备上线
	# 	Then RPC返回结果只有'<result_message>'
	#
	# 	Examples:
	# 		| parameter | result_message |
	# 		| Device.Error. | FaultCode:9005FaultString:Invalid parameter name |
	# 		| Device.Error | FaultCode:9005FaultString:Invalid parameter name |
	# 		| Device.DeviceInfo.ModelName, Device.DeviceInfo.Error | FaultCode:9005FaultString:Invalid parameter name |
	# 		| Device.SoftwareModules.DeploymentUnit. | Success |
	# 		| Device.ManagementServer.Password | Name:Device.ManagementServer.PasswordType:stringValue: |
