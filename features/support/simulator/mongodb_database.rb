
class Device
  include Mongo::Document

  DEVICE_1 = {
  "version"=>0,
  "create_time"=>'',
  "modify_time"=>'',
  "name"=>"auto_test0",
  "oui"=>"",
  "product_class"=>"",
  "manufacturer"=>"",
  "model"=>"",
  "serial_number"=>"000000000100",
  "ip_address"=>"",
  "last_online_time"=>'',
  "firmware_version"=>"",
  "hardware_version"=>"",
  "protocol"=>"CWMP",
  "number_of_informs"=>0,
  "domain"=>"",
  "tags"=>[],
  "username"=>"root",
  "conn_req_url"=>"",
  "udp_conn_req_addr"=>"",
  "nat_detected"=>false,
  "port"=>161,
  "community"=>"public",
  "rack"=>0,
  "slot"=>0,
  "coordinate"=>[0.0, 0.0]
  }
end
