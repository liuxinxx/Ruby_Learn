# encoding: utf-8
# require 'mechanize'
# require 'uri/http'
# require 'open-uri'
require 'rubygems'
require 'net/http'
require 'open-uri'
class DOW
  def download_html(url)
    begin
      agent = Mechanize.new
      agent.user_agent_alias = "Linux Mozilla"
      # puts agent.methods
      $proxy_addr = '113.69.38.106'
      $proxy_port = '808'
      # html = ''
      # Net::HTTP.version_1_2
      # Net::HTTP::Proxy($proxy_addr, $proxy_port).start(url) {|http|
      # html= http.get('')
      # str = html
      # # str.encoding = 'gbk'
      # puts str
      # }
       html = agent.get(url)
      return html
      # html = open(url).read
    rescue Exception=> e
      puts "出现异常:"+e.message
      puts e.backtrace
      puts e.class
      return "0"
    end
  end
end