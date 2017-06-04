# encoding: utf-8
require 'mechanize'
require 'rubygems'
require 'net/http'
require 'open-uri'
require 'watir'
class DOW
  public
  def download_html(url)
    begin
      agent = Mechanize.new
      agent.user_agent_alias = "Linux Mozilla"
      html = agent.get(url)
      return html
    rescue Exception=> e
      puts "出现异常:"+e.message
      return "0"
    end
  end
  def download(url)
    b = Watir::Browser.new(:chrome)
    # b = Watir::Browser.new(:phantomjs)
    b.goto(url)
    return  b.html
  end
  def download_proxy(url)
    begin
      $proxy_addr = '113.69.38.106'
      $proxy_port = '808'
      Net::HTTP.version_1_2
      Net::HTTP::Proxy($proxy_addr, $proxy_port).start(url) {|http|
      html= http.get('')}
      return html
    rescue Exception=> e
      puts "出现异常:"+e.message
      puts e.backtrace
      puts e.class
      return "0"
    end
  end
end