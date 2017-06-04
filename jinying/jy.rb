require '../class_all'
require 'uri'
require 'nokogiri'
@number = 29
def num(tr)#记录td个数
  sum =0
  td = Array.new
  tr.xpath('td').each do |n|
    str = n.content.gsub("\r\n","").gsub('/',"、").gsub(' ',"").gsub('\t',"").gsub("      ","").gsub("									","").gsub("			","")
    sum+=1
    td[sum] = str
  end
  return sum,td
end
def jiexi_1(html,pc,file)
  info = {"奖项"=>'',"获奖剧目"=>'',"制作单位"=>''}
  html.xpath('//*[@id="wrapper"]/div[5]/div[1]/div[3]/table/tbody/*').each do |tr|
        n,td_a = num(tr)
        # p n ,td_a
        if td_a[1]=='奖项'||n==1
          next
        end
        if n==2
          info["获奖剧目"] = td_a[1]
          info["制作单位"] = td_a[2]
        end
        if n==3
          info["奖项"] = td_a[1]
          info["获奖剧目"] = td_a[2]
          info["制作单位"] = td_a[3]
        end
    str = ''
    info.each do |key,vol|
      str+=vol+','
    end
        if str!=",,,"
        print str.chop+','+pc+','+@number.to_s
        puts
        end

    # p tr.content.gsub("\r\n",",").gsub(" ","").gsub("      ",""),pc
    # str = tr.content.gsub("\r\n",",").gsub(" ","").gsub("      ","").gsub("\t","")+','+pc+"\r\n"
    # file.syswrite(str)
  end
end
def main_url(url)
  url_list = Hash.new
  dow = DOW.new
  html = dow.download_html(url)
             # //*[@id="wrapper"]/div[5]/div[1]/div[2]/div/ul/li[11]/span[1]/a
  html.xpath('//*[@id="wrapper"]/div[5]/div[1]/div[2]/div/ul/li/span/a').each do |li|
    li_url = li['href']
    li_txt = li.content
    url_list[li_txt] = 'http://www.ctaa.org.cn' + li_url
  end
  url_list
end
def jiexi_2(html,pc)
  strong = Hash.new
  sss = ""
  flag = 0
  html.xpath('//div[@align="left"]/strong').each do |div|
    strong[div.content] = div.content
  end
  html.xpath("//div[@align='left']").each do |div|
    d=div.content.gsub("\r\n","").gsub(/ |　/,"").gsub("\n",'').gsub("》","》,")

    if /：/ =~ d
      print d.gsub("：",","),',',pc
      puts
      next
    end
    #  |　　
    if strong[d]
      if flag ==0
        sss+=d+','
        flag =1
      else
        print d,',',sss,',',pc
        puts
        sss=''
        flag =0
      end
    else
      sss+=d
    end
  end

end

dow = DOW.new
url = 'http://www.ctaa.org.cn/a/jinyingjiang/'
main_url(url).each do |key,vol|
  @number-=1
  pc = ''
  file =  File.new('/media/liuxin/python/Ruby/RubymineProjects/jinying/all.csv','a+')
  if key =~/^(第.*届)大|^(第.*届)中/
    pc = $1 || $2
  end
  html = dow.download_html(vol)
  if @number == 23
    jiexi_2(html,pc)
  else

    # jiexi_1(html,pc,file)
  end

  # file.syswrite(html.body) #写入到本地，避免ip被封
end
