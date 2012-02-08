#encoding: utf-8
require 'rubygems'
require 'net/http'

#抓取开始
Net::HTTP.version_1_2


resp = Net::HTTP::Proxy("192.168.16.189", 8080, "geliang","gelianga").start('jsmcc6.newhua.com') do |http|
  resp = http.get("/down/MSNOIE8_ZHCN_XP.zip")
  puts resp.is_a? Net::HTTPRedirection 
  puts resp.body
  puts resp["status"]
  puts resp["content-length"]
end

=begin
require 'progressbar'

url = "http://sqmcc2.newhua.com:82/down/MSNOIE8_ZHCN_XP.zip"
uri = URI.parse(url)
host = uri.host + ":" + uri.port.to_s
file_path = uri.path
if uri.query
  file_path += "?" + uri.query
end
@counter = 0

Net::HTTP::Proxy("192.168.16.189", 8080, "geliang", "gelianga").start(host) do |http|
  response = http.request_head(file_path)
  puts response['content-length']
  pbar = ProgressBar.new("file name:", response['content-length'].to_i)
  File.open("test.file", 'w') { |f|
    http.get(file_path) do |str|
      f.write str
      @counter += str.length
      pbar.set(@counter)
    end
  }
  pbar.finish
end

puts "Done."
=end