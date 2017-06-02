require '../class_all'
require 'mechanize'
#/html/body/div[3]/div[2]/div/div[2]/div|
#/html/body/div[4]/div[2]/div/div[2]/div[65]/h3
def jiexi(html)
  divs = html.xpath("//div[@label-module='para-title']//h3|//td")
  jie = ''
  time = ''
  s =''
  j = 0
  divs.each {|div|
    j+=1
    str = div.content.gsub("\r\n",'').gsub("\n",'')
    if /^中国.*（[0-9].*年）[0-9].*人/=~ str or /获奖演员.*人/ =~str or /^获奖名单.*/=~str
    else
      if /梅花表演奖(第.*届)（(.*年)/ =~ str
        jie = $1
        time = $2
      else
        s = s + str+','
        # p s
        end
    end
    if j==2
        print s,jie,',',time
        puts
        s = ''
        j = 0
    end

  }
end

url ='http://baike.baidu.com/link?url=PHb33Q86G_bdYJvqR_UXbXHuUNeyZDn3Ie1MHko7fXvNik_7fQnAfvHfiwWZSV0yBIuhRGkCtajwez3KaXTjGhhfKhKoJ27mAZYGS1YhpCzVGAjOIIy6hKqmehc1ZXZD9ptyq5_xp6Wh70TvdBMRM6vxjcC-SzUiQt17G8fKz2HZKEOolj5au4i3fal208ypXsx5Il8e0CrrDsdkuDs2GvL66VWdz654b6XAmsZY2MNyiOYvaKAGvfCdVSIIkzDThlqEBOzOX70cMYTM9TIOJK'
dow = DOW.new
html = dow.download_html(url)
jiexi(html)