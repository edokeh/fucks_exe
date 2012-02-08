#encoding:utf-8
class Pcode < ActiveRecord::Base
  #生成随机码
  def self.generate
    seed = (65..90).to_a + (97..122).to_a
    rand_str = ""
    12.times do
      index = rand(seed.size)
      rand_str << seed[index]
    end
    self.create(:code=>rand_str)
  end

  def self.allow?(code)
    pcode = self.where("code=?", code).first
    if pcode
      puts pcode.code
      pcode.increment!(:used_count)
      pcode.delete if pcode.used_count >= 2
    end
    return !(pcode.nil?)
  end
end
