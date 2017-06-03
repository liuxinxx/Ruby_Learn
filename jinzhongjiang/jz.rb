require '../class_all'
require 'uri'
require 'nokogiri'
@sum =0
def infobox(html,pc)
  ##获取该届的情况
  info={"批次"=>pc,"时间"=>"#","日期"=>"#","地点"=>"#","国家或地区"=>"#","主办方"=>"#","主持人"=>"#","电视网络"=>"#"}
  html.xpath("//div[@id='bodyContent']").each do |div|
    if /第.*[0-9]届金钟奖.*是(.*[0-9].*)年台湾/=~div.content
      info["时间"]=$1.to_s
    end
  end
  html.xpath("//table[@class='infobox vevent']/tr").each do |tr|
    td =tr.content.split(" ")
    if info[td[0]]
      info[td[0]] = td[1].to_s+td[2].to_s+td[3].to_s+td[4].to_s
    end
  end
  return info
end
def table_td_max(html)
  table_max = Hash.new
  table = 0
  x = 0
  html.xpath("//table[@class='toccolours']").each do |tr|
    max =0
    tr.xpath("tr").each do | td|
      table+=1
      td.xpath("td").each do | h|
          x+=1
      end
      if max<x
        max =x
      end
      x=0
      table_max[table.to_s] = max
    end
  end
  return table_max
  end
def td_num(tr)
  i =0
  ar = Array.new
  tr.xpath('td').each do |td|
    i+=1
    ar[i] = td.content.gsub(",","，").gsub("\n","，")
  end
  return ar
end
def jiexi(html,file,infobox)
  ids = html.xpath("//table[@class='toccolours']/tr|//span[@class='mw-headline']")
  info = {"获奖"=>"#","入围／得奖者"=>"#","入围／得奖作品"=>"#","制作公司／广播公司"=>"#","颁奖嘉宾"=>"#"}
  h_2 =''
  h_3 =''
  h_4 =''
  name_num=0
  h2h = Hash.new
  h3h = Hash.new
  h4h = Hash.new
  name = Hash.new
  ##获取大标题
  h2s = html.xpath('//h2')
  h2s.each do |h2|
    if /(.*?)\[编辑\]/=~h2.content
      h2h[$1] =$1
      # puts $1+'--->h2'
    end
  end
  ##二级标题
  h3s = html.xpath('//h3')
  h3s.each do |h3|
    if /(.*?)\[编辑\]/=~h3.content
      h3h[$1] =$1
    end
  end
  ##小标题
  h4s = html.xpath('//h4')
  h4s.each do |h4|
    if /(.*?)\[编辑\]/=~h4.content and h4.content.size!=0
      h4h[$1]=$1
    end
  end

  trss = html.xpath("//table[@class='toccolours']/tr")
  p = 0
nn =''
trss.each do |trr|
  ##评委名字
  p+=1
  names = trr.xpath('td[@rowspan]')
  names.each do|na|
    na = na.content.gsub("\r\n","").gsub("\n","").gsub(" ","")
      name[p.to_s] = na
    nn =na
      # p name[p.to_s]+p.to_s
  end
  name[p.to_s] = nn
  # p name[p.to_s]+p.to_s
  # num_tr+=1
  # p num_tr.to_s,trr.content.gsub("\r\n","").gsub("\n","").gsub(" ","")
end

table_td_max = table_td_max(html)
ids.each do |id|
  if h2h[id.content]
    h_2 = h2h[id.content]
    next
  elsif h3h[id.content]
    h_3 = h3h[id.content]
    next
  elsif h4h[id.content]
    h_4 = h4h[id.content]
    next
  else
    name_num += 1
    n = table_td_max[name_num.to_s]
    ar =td_num(id)
    if n==0
      next
    end
    if n==2
      info["获奖"]=ar[1]
      info["入围／得奖者"]="#"
      info["入围／得奖作品"] = "#"
      info["制作公司／广播公司"] = "#"
      info["颁奖嘉宾"]=ar[2]
    end
    if n==3
      info["获奖"]=ar[1]
      info["入围／得奖者"]=ar[2]
      info["入围／得奖作品"] = "#"
      info["制作公司／广播公司"] = ar[3]
      info["颁奖嘉宾"]=name[name_num.to_s]

    end
    if n==4
      info["获奖"]=ar[1]
      info["入围／得奖者"]="#"
      info["入围／得奖作品"] = ar[2]
      info["制作公司／广播公司"] = ar[3]
      info["颁奖嘉宾"]=name[name_num.to_s]
    end
    if n ==5
      info["获奖"]=ar[1]
      info["入围／得奖者"]=ar[2]
      info["入围／得奖作品"] = ar[3]
      info["制作公司／广播公司"] = ar[4]
      info["颁奖嘉宾"]=name[name_num.to_s]
    end
    ssss = ''
    info.each do |key,vlo|
      ssss+=vlo.to_s+','
    end
    ssss=ssss+h_2+'-'+h_3+'-'+h_4+','
    infobox.each do |key,vlo|
      ssss+=vlo.to_s+','
    end
    print ssss
    file.syswrite(ssss+"\r\n")
    @sum+=1
    puts
  end
  end
end
file = File.new("/media/liuxin/python/Ruby/RubymineProjects/jaj/alls.csv", 'a+')
(1..51).each do |n|
    url = 'https://zh.wikipedia.org/zh-cn/'
    str = '第'+n.to_s+'屆金鐘獎'

    final_url = URI::escape(url+str)#中文url转换
    dow = DOW.new
    html = dow.download_html(final_url)
    pc  = n.to_s+'届'
    infobox = infobox(html,pc)
    jiexi(html,file,infobox)
end
puts @sum #1-52届总共7934个名单