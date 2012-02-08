#encoding:utf-8
require 'net/http'
Net::HTTP.version_1_2

class URI::HTTP
  def full_path
    if self.query
      self.path + "?" + self.query
    else
      self.path
    end
  end
end

class HttpDownload
  extend ActionView::Helpers::NumberHelper
  @@proxy = Rails.env.development? ? "192.168.16.187" : nil
  
  #根据url获取文件大小
  def self.get_url_size(url, pcode=nil)
    uri = URI.parse(url)
    size = nil
    error = nil
    begin
      resp = Net::HTTP::Proxy(@@proxy, 8080, "geliang", "gelianga").start(uri.host, uri.port) do |http|
        resp = http.head(uri.full_path)
        if resp.is_a? Net::HTTPRedirection
          return self.get_url_size(resp["location"], pcode)
        elsif resp.is_a? Net::HTTPSuccess
          size = resp["content-length"].to_i
        else
          error = "url请求失败！"
        end
      end
    rescue => e
      error = e.message.encode("UTF-8")
    end
    max_size = Auth.max_size(pcode)
    error = "不能下载超过#{number_to_human_size(max_size)}的文件" if size && size > max_size
    return size, error
  end

  #根据url下载文件
  def self.download(url, id, pcode=nil, &block)
    uri = URI.parse(url)

    Net::HTTP::Proxy(@@proxy, 8080, "geliang", "gelianga").start(uri.host, uri.port) do |http|
      resp = http.head(uri.full_path)
      if resp.is_a? Net::HTTPRedirection
        self.download(resp["location"], id, pcode, &block)
      elsif resp.is_a? Net::HTTPSuccess
        total = resp['content-length'].to_i
        return if total > Auth.max_size(pcode)
        curr = 0
        File.open(Rails.root.join("tmp", "download", id.to_s), 'wb') do |f|
          http.get(uri.full_path) do |str|
            f.write str
            curr += str.length
            block.call(curr, total)
          end
        end
      end
    end
  end
end