class UnoMS

  def stop
    system("echo 123456 | sudo -S systemctl stop unoms", :out => File::NULL)
  end

  def start
    system("echo 123456 | sudo -S systemctl start unoms", :out => File::NULL)
  end
end
