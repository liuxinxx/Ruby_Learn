require '../class_all'
def jiexi(html, file)
  html.xpath('//div[@class="wai"]').each do |div|
    leixin = ''
    div.xpath('.//div[@class="zi"]').each do |tag|
      leixin =tag.content.gsub("\t", "").gsub("\r\n", "").gsub(" ", "")
    end

    div.xpath('.//li/ul/li').each do |li|
      str =''
      name = li.content.gsub("\t", "").gsub("\r\n", "").gsub(" ", "")
      if leixin =="外资银行"
        name = name.gsub("分行", "")
      end
      li.xpath('.//a').each {|a|
      url = a['href']
        if url =="http://"
          url = " "
        end
      str = leixin+','+name+','+url
       p str
      file.syswrite(str+"\r\n")
      }
    end

  end
end

file = File.new("/media/liuxin/python/Ruby/RubymineProjects/jaj/yh12.csv", 'a+')
url ='http://www.cbrc.gov.cn/chinese/jrjg/index.html'
dow = DOW.new
html = dow.download_html(url)
jiexi(html, file)

