require 'mechanize'
require 'uri/http'
require 'open-uri'
class CCTV
  def dow_html(url)
    agent = Mechanize.new
    #p agent.methods 打印该对象下的方法
    html = agent.get(url)
    return html
  end

  def jiexi_to_hxt(html, file_name)
    #divs = html.xpath("//h3[@class='title-text']|//div[@class='para']")
    divs = html.xpath("/html/body/div[3]/div[2]/div/div[2]/div")
    flag = 0
    n = 0
    divs.each {|div|

      lei = ''
      str = div.content.gsub("\n", "").gsub("[", "").gsub("]", "")
      if /^CCTV中国经济年度人物[1-9].*年度$/=~str and flag != 1
        # p str
        flag = 1
      end
      if flag ==1 and str.size <200 and str.size > 3
        n+=1
        file_name.syswrite(str.gsub("　　", "\r\n").gsub("　", " ")+"\r\n")
      end
    }
  end
end

def to_csv(file_uri)
  file = File.open(file_uri)
  str = ''
  y = ''
  # 人物([0-9].*?),
  file.each_line {|line|
    line = line.gsub("\r\n", "")
    if /CCTV中国经济年度人物([0-9].*?年度)/=~line
      y = $1
      str =''
      puts "    "
      next
    end

    if /.、(.*?)奖/=~line
      str = $1+"奖"
      next
    elsif /.*商业领袖/=~line
      str = $&+"奖"
      next
    end
    print line.gsub(" ", ",") +","+y+","+str
    puts
  }
  file.close()
  File.delete(file)
end

url = 'http://baike.baidu.com/link?url=2gzjqKgV5jWwt1hgmnV2SGhZNRCvWe5YZILghUifduaFJSo2pK5HrEW0xJDbYUkCxrvY4ZMJYajW3OMChxnZd0BmcBunE4i3-VPmapz3Hp77f0niuo6Igv-X0C3rZznTJyKIBcdKMCzwPGXiwVPFFI6cNvlNB5OUYjpx-kNHqfZaWTPJS8lzurD4NfpZWoZN#3'
cctv = CCTV.new
doc = cctv.dow_html(url)
file_uri = '/media/liuxin/python/Ruby/RubymineProjects/12.txt'
file= File.new(file_uri, "a+")
cctv.jiexi_to_hxt(doc, file)
to_csv(file_uri)