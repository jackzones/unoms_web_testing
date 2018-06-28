class UnoMS
  
  def stop
    system("echo op[]=-09 | sudo -S systemctl stop unoms", :out => File::NULL)
  end

  def start
    system("echo op[]=-09 | sudo -S systemctl start unoms", :out => File::NULL)
  end
end
