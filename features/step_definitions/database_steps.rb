Given /^系统中存在一个设备$/ do
  Device.insert_one(DEVICE1)
  binding.pry
end
