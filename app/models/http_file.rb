class HttpFile < ActiveRecord::Base
  before_save :set_filename
  before_destroy :delete_file

  def set_filename
    path = URI.parse(url).path
    self.filename = path[path.rindex("/") + 1..-1]
  end

  #更新进度
  def update_percent(curr, total)
    percent = (curr.to_f / total.to_f)*100
    update_attribute(:size, total) if self.size.nil?
    update_attribute(:percent, percent)
  end

  def delete_file
    begin
    File.delete(Rails.root.join("tmp", "download", id.to_s))
    rescue
    end
  end

end
