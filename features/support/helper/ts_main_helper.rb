
require_relative 'main_helper'
include MainHelper

describe "testing to_array_by_semicolon" do

  it "should be 二维数组" do
    # song1.to_s.should == "Song: Magic-Sun-200"
    str = "name:type:value, nelson:string:2"

    expect(to_array_by_semicolon(str)).to eq([%w(name type value), %w(nelson string 2)])
  end

  it "should be 能处理多余空格" do
    # song1.to_s.should == "Song: Magic-Sun-200"
    str = "name :type: value,  nelson: string:2"

    expect(to_array_by_semicolon(str)).to eq([%w(name type value), %w(nelson string 2)])
  end

#   it "should be green when data is ok" do
#     data_arr = []
#     data_arr << DataSensor.new("2018-07-12 10:16:16 -06:00", 509)
#     data_arr << DataSensor.new("2018-07-12 10:13:16 -06:00", 508)
#     data_arr << DataSensor.new("2018-07-12 10:10:16 -06:00", 506)
#     data_arr << DataSensor.new("2018-07-12 10:07:16 -06:00", 504)
#     data_arr << DataSensor.new("2018-07-12 10:04:16 -06:00", 506)
#     now_time = DateTime.parse('Thu Jul 12 10:16:30 CST 2018')
#
#     expect(time_ok?(data_arr, now_time)).to eq('time'.colorize(:green))
#   end
#
#   it "should be red when a data timeout" do
#     data_arr = []
#     data_arr << DataSensor.new("2018-07-12 10:16:16 -06:00", 509)
#     data_arr << DataSensor.new("2018-07-12 10:12:16 -06:00", 508)
#     data_arr << DataSensor.new("2018-07-12 10:10:16 -06:00", 506)
#     data_arr << DataSensor.new("2018-07-12 10:07:16 -06:00", 504)
#     data_arr << DataSensor.new("2018-07-12 10:04:16 -06:00", 506)
#     now_time = DateTime.parse('Thu Jul 12 10:16:30 CST 2018')
#
#     expect(time_ok?(data_arr, now_time)).to eq('time'.colorize(:red))
#   end
#
#   it "should be red when the device break down" do
#     data_arr = []
#     data_arr << DataSensor.new("2018-07-12 10:01:16 -06:00", 509)
#     # data_arr << DataSensor.new("2018-07-12 10:12:16 -06:00", 508)
#     # data_arr << DataSensor.new("2018-07-12 10:10:16 -06:00", 506)
#     # data_arr << DataSensor.new("2018-07-12 10:07:16 -06:00", 504)
#     # data_arr << DataSensor.new("2018-07-12 10:04:16 -06:00", 506)
#     now_time = DateTime.parse('Thu Jul 12 10:16:30 CST 2018')
#
#     expect(time_ok?(data_arr, now_time)).to eq('time'.colorize(:red))
#   end
# end
#
# describe "testing data_ok?" do
#
#   it "should be green when data is ok" do
#     data_arr = []
#     data_arr << DataSensor.new("2018-07-12 10:16:16 -06:00", 509)
#     data_arr << DataSensor.new("2018-07-12 10:13:16 -06:00", 508)
#     data_arr << DataSensor.new("2018-07-12 10:10:16 -06:00", 506)
#     data_arr << DataSensor.new("2018-07-12 10:07:16 -06:00", 504)
#     data_arr << DataSensor.new("2018-07-12 10:04:16 -06:00", 506)
#
#     expect(data_ok?(data_arr)).to eq('data'.colorize(:green))
#   end
#
#   it "should be red when data is the same" do
#     data_arr = []
#     data_arr << DataSensor.new("2018-07-12 10:16:16 -06:00", 506)
#     data_arr << DataSensor.new("2018-07-12 10:13:16 -06:00", 506)
#     data_arr << DataSensor.new("2018-07-12 10:10:16 -06:00", 506)
#     data_arr << DataSensor.new("2018-07-12 10:07:16 -06:00", 506)
#     data_arr << DataSensor.new("2018-07-12 10:04:16 -06:00", 506)
#
#     expect(data_ok?(data_arr)).to eq('data'.colorize(:red))
#   end
#
#   it "should be red when data is empty" do
#     data_arr = []
#
#     expect(data_ok?(data_arr)).to eq('data'.colorize(:red))
#   end
end
