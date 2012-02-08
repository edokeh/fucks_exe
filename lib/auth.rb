#encoding:utf-8
#权限相关
module Auth
  ADMIN = {"geliang"=>"wori"}

  MAX_SIZE = 30.megabytes

  def self.max_size(pcode)
    if pcode && Pcode.allow?(pcode)
      500.megabytes
    else
      MAX_SIZE
    end
  end
end