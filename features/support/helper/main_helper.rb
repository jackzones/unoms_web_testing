module MainHelper

  # 小写字母（26个）和数字（10个）组成
  def gen_random_str(len)
      rand(36 ** len).to_s(36)
  end
  
end
