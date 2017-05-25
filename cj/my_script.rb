# encoding: utf-8
require 'net/http'
require 'nokogiri'
require 'open-uri'
require 'rubygems'
require 'mechanize'
class CJ
  def main_list(uri)
    all_list =Hash.new
    doc = Nokogiri::HTML(open(uri))
    doc.css('a').each do |link|
      if /名单|教授/=~link.content
        all_list[link.content.gsub("·", "")] = "http://www.cdgdc.edu.cn"+link['href']
      end
    end
    return all_list
  end

  def jiexi(uri, file_name)
    num = Array.new
    agent = Mechanize.new
    #p agent.methods 打印该对象下的方法
    html = agent.get(uri)
    html.encoding = "gbk"
    #p html.encoding 获取该文本的编码方式
    numm = html.xpath("//p[@align='center']/b")
    if numm.size==0
      numm = html.xpath("//div//strong")
    end
    n = 0;
    numm.each {|nu|
      if /([0-9].*[0-9])/ =~ nu
        num[n]=$&
        n+=1
        num[n]=nu.content
        n+=1
      end
    }
    tds=html.xpath("//table//tbody//tr")
    if tds.size == 0
      tds=html.xpath("//table//thead//tr")
    end
    lin =''
    name = 0
    tds.each {|lines|
      tds1 = lines.xpath("td")
      tds1.each {|li|
        lin+=li.content.gsub(',', '、')+','
      }
      if tds1.size == 3 &&num[0]!=nil
        name+=1
        if name<=num[0].to_i
          lin+='特聘,'
        else
          lin+='讲师,'
        end
      end
      if lin!=''
        lin = lin.chop
        if lin.size<200
          file_name.syswrite(lin+"\r\n")
        end
      end
      p lin
      lin = ''
    }
  end
end
hp = CJ.new
main_uri = "http://www.cdgdc.edu.cn/xwyyjsjyxx/xwsytjxx/276578.shtml"
all_list = hp.main_list(main_uri)
all_list.each {|key, value|
  p key, value
  file= File.new('/home/liuxin/RubymineProjects/test1/'+key+".csv", "a+")
  hp.jiexi(value, file)
}
