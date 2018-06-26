class SimTR

  attr_accessor :app_conf_file, :digest_url_without_rkey, :license_file

  def initialize(
    app_conf_file='/home/arthur/unotr/conf/app.conf',
    digest_url_without_rkey='http://127.0.0.1/sbi/cwmp/digest',
    license_file = "/home/arthur/Documents/unoms_web_testing/features/support/others/ubuntu_auto_CWMP.lic"
  )
    @app_conf_file = app_conf_file
    @digest_url_without_rkey = digest_url_without_rkey
    @license_file = license_file
  end

  def input(filename,s)
    File.open(filename,'w+') do |file|
      file.write s
    end
  end

  def output(filename,reg,sub_str)
    s = ""
    File.open(filename,'r+') do |file|
      file.each_line do |line|
        line = line.gsub(reg, sub_str)
        s += line
      end
    end
    s
  end

  def stop
    # `pkill -9 unotr`
    # `echo op[]=-09 | sudo -S systemctl stop unotr`
    system("echo op[]=-09 | sudo -S systemctl stop unotr", :out => File::NULL)
  end

  def start
    # `/Users/jackzones/unosys/simutator/unotr/unotr`
    # `echo op[]=-09 | sudo -S systemctl start unotr`
    system("echo op[]=-09 | sudo -S systemctl start unotr", :out => File::NULL)
    # `cd /Users/jackzones/unosys/simutator/unotr`
    # `./unotr`
  end

  def modify_sn(sn)
    filename = @app_conf_file
    self.input(filename,self.output(filename,/serialNumberFrom=.*/, "serialNumberFrom=#{sn.to_i}"))
    self.input(filename,self.output(filename,/serialNumberTo=.*/, "serialNumberto=#{sn.to_i}"))
  end

  def device_register(serial_number)
    self.stop
    self.modify_sn(serial_number)
    self.start
    sleep 1
  end

  def data_model_path
    filename = @app_conf_file
    File.open(filename, 'r+') do |file|
      s = ''
      file.each_line do |line|
        s += line.match(/^presentationConfig=(.*)/)[1] if line.match(/^presentationConfig=(.*)/)
      end
      s =~ %r{^lib/dmt} ? s = self.app_conf_file.split('conf/app.conf')[0] + s : s
    end
  end

  def set_acs_info(url, username, password)
    data_model_file = self.data_model_path
    self.input(data_model_file,self.output(data_model_file,/<URL writable="true" pattern="http">.*<\/URL>/, "<URL writable=\"true\" pattern=\"http\">#{url}</URL>"))
    self.input(data_model_file,self.output(data_model_file,/<Username writable="true">.*<\/Username>/, "<Username writable=\"true\">#{username}</Username>"))
    self.input(data_model_file,self.output(data_model_file,/<Password writable="true" password="true">.*<\/Password>/, "<Password writable=\"true\" password=\"true\">#{password}</Password>"))
  end

  def modify_oui(oui)
    data_model_file = self.data_model_path
    self.input(data_model_file,self.output(data_model_file,/<ManufacturerOUI>(.*)<\/ManufacturerOUI>/, "<ManufacturerOUI>#{oui}</ManufacturerOUI>"))
  end
end
