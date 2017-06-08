# encoding: utf-8
require 'mechanize'
require 'open-uri'
require 'uri/http'
require 'nokogiri'
require '../class_all'
class KJ

  def main_url(url)
    all_url = Hash.new
    dow = DOW.new
    begin
      html = dow.download_html(url)
      html.encoding ='gbk'
      doc= html.xpath('//*[@id="NewsList"]/table/tbody/tr[2]/td/table/tbody/tr/td[2]/*/tbody/tr/td[2]/div/a')
      doc.each {|line|
        url_txt = line.content.gsub("\t", "").gsub("\n", "").gsub(" ", "")
        url = line['href']
        if /(.*?.htm)/=~ url
          all_url[url_txt] = "http://www.most.gov.cn/cxfw/kjjlcx/"+$&
        end
      }
    rescue Exception => e
      puts e.message
    end
    return all_url
  end

  def jiexi(url, file_name)
    dow = DOW.new
    html = dow.download_html(url)
    if html!="0"
      html.encoding = 'gbk'
      flag = 0
      ##国家技术发明奖
      lines = html.xpath("//*[@id=\"Zoom\"]/*/span|//*[@id=\"Zoom\"]/*/*/span|//*[@id=\"Zoom\"]/table[1]/tbody/*/*/p|//*[@id=\"Zoom\"]/div[2]/table/tbody/*/*/*")
      if lines.size ==0
        ##国家自然科学奖
        lines = html.xpath("/html/body/div[7]/div[2]/table/tbody/*/td")
        flag = 1
      end
      if lines.size ==0
        #2014年国家自然科学奖获奖项目目录
        lines = html.xpath("/html/body/div[7]/table[1]/tbody/*/*/p")
        flag = 2
      end
      if lines.size ==0
        #2014年国家自然科学奖获奖项目目录
        lines = html.xpath("/html/body/div[3]/div[4]/table[1]/tbody/*")
        flag = 3
      end
      if lines.size == 0
        lines = html.xpath("//*[@id=\"Zoom\"]/div[2]/font/div/table/tbody/*/*/p")
        flag = 4
      end
      puts "flag--->"+flag.to_s
      puts lines.size
      lines.each {|line|
        line = line.content.to_s.gsub("\r\n", "")
        p line.gsub(" ","")
        # file_name.write(line.gsub(" ", "").gsub("\n\n", ",")+"\r\n")
      }
    end
  end
end

kj = KJ.new
url = 'http://www.most.gov.cn/cxfw/kjjlcx/index.htm'
  kj.main_url(url).each {|key, value|
    url='file://'
    p key, value
    dow = DOW.new
    html = dow.download_html(value)
    if html!="0"
    file = File.new("/media/liuxin/python/Ruby/RubymineProjects/jiang/"+key+".html", 'a+')
    # kj.jiexi(value, file)
    file.syswrite(html.body)
    end
  }

# 2001国家技术发明奖
# url = "http://www.most.gov.cn/cxfw/kjjlcx/kjjl2001/200802/t20080214_59033.htm"

##2015国家自然科学奖
# url ="http://www.most.gov.cn/ztzL/gjkxjsjldh/jldh2015/jldh15jlgg/201601/t20160106_123343.htm"

##技术进步奖
# url = "http://www.most.gov.cn/cxfw/kjjlcx/kjjl2000/200802/t20080214_59081.htm"

##2014年国家自然科学奖获奖项目目录
# url = "http://www.most.gov.cn/ztzl/gjkxjsjldh/jldh2014/jldh14jlgg/201501/t20150107_117322.htm"
file = File.new("/media/liuxin/python/Ruby/RubymineProjects/jiang/123.csv", 'a+')
kj.jiexi('http://www.most.gov.cn/cxfw/kjjlcx/kjjl2001/200802/t20080214_59033.htm', file)