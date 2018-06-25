class UnoMS

  # attr_accessor :app_conf_file, :digest_url_without_rkey, :license_file
  #
  # def initialize(
  #   app_conf_file='/home/arthur/unotr/conf/app.conf',
  #   digest_url_without_rkey='http://127.0.0.1/sbi/cwmp/digest',
  #   license_file = "/Users/jackzones/Wing/unoms_web_testing/features/support/others/auto_CWMP.lic"
  # )
  #   @app_conf_file = app_conf_file
  #   @digest_url_without_rkey = digest_url_without_rkey
  #   @license_file = license_file
  # end


  def stop
    # `pkill -9 unotr`
    # `echo op[]=-09 | sudo -S systemctl stop unoms`
    system("echo op[]=-09 | sudo -S systemctl stop unoms", :out => File::NULL)
  end

  def start
    # `/Users/jackzones/unosys/simutator/unotr/unotr`
    # `echo op[]=-09 | sudo -S systemctl start unoms`
    system("echo op[]=-09 | sudo -S systemctl start unoms", :out => File::NULL)
    # `cd /Users/jackzones/unosys/simutator/unotr`
    # `./unotr`
  end

  # def modify_sn(sn)
  #   filename = @app_conf_file
  #   self.input(filename,self.output(filename,/serialNumberFrom=.*/, "serialNumberFrom=#{sn.to_i}"))
  #   self.input(filename,self.output(filename,/serialNumberTo=.*/, "serialNumberto=#{sn.to_i}"))
  # end



end
