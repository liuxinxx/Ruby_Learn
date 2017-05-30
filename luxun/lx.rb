require 'mechanize'
require 'open-uri'
require 'uri/http'
require 'nokogiri'
require '../class_all'
def jiexi(html)
  trs = html.xpath('/html/body/div[3]/div[2]/div/div[2]/div')
  puts trs.size()
  flag = 0
  info = Hash.new
  time1 = ''
  trs.each{|line|
    line = line.content.gsub("\r\n","").gsub(" ","").gsub("\n","").gsub("：",",")
    if /金鸡百花奖第(.*?)届（[1-9].*年）/=~line
      time1 = $1
      flag = 1
    end
    if /时间.*|地点.*/=~line and flag ==1
      if info[time1] == nil
      info[time1] = $&.to_s + info[time1].to_s
      else
        info[time1] = $&
        end
    end
    if line.size >5 and line.size < 50 and flag == 1
      print line,',第',time1+"届",info[time1]
    puts
    end
  }
  # puts html.body
end
url = 'http://baike.baidu.com/item/%E9%87%91%E9%B8%A1%E7%99%BE%E8%8A%B1%E5%A5%96#3_30'
lx = DOW.new
html = lx.download_html(url)
jiexi(html)