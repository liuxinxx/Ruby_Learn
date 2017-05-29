# encoding: utf-8
# require 'mechanize'
# require 'uri/http'
# require 'open-uri'
class DOW
  def download_html(url)
    begin
      agent = Mechanize.new
      agent.user_agent_alias = "Linux Mozilla"
      # agent.open_timeout = 10
      # puts agent.methods
      html = agent.get(url)
    rescue Exception=> e
      puts "出现异常:"+e.message
      puts e.backtrace
      puts e.class
      return "0"
    end
    agent.history.clear
    return html
  end
end