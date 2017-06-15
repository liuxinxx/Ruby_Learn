# encoding: utf-8
require 'uri/http'
require 'mechanize'
require 'nokogiri'
require '../class_all'
class AD
  def initialize
    @dow = DOW.new
    @url_list = Array.new
    @number = 0
  end

  def root_url(url)
    flag = 1
    html = @dow.download_html(url)
    root = url[0, url.rindex("/")+1]
    html.xpath('//div[@class="neiwen"]/*/tr').each do |div|
      pc = ''
      div.xpath('.//span').each do |sp|
        if /.*赛.*/=~sp.content
          pc = $&
        else
          sp.xpath('a').each do |a|
            a = [flag, pc, a.content, root+a['href']]
            @url_list.push(a)
          end
        end
      end
    end
    return @url_list
  end
  def html_edcode(html)
    html.xpath("//html").each do |h|
      h.to_s.encode!('gb2312')
      return h
    end
  end
  def array_to_str(a)
    str =''
    a.each do |aa|
      str+=aa.to_s+','
    end
    return str.chop
  end
  def all_url
    page = []
    file = File.open('./all.csv','ab+')
    while !@url_list.empty?
      data = @url_list.shift #出队列一个
      url = data[data.size-1] ##取倒数第二个，倒数第二个存入的是链接
      flag = data[0] ##取标记
      # data.shift##取出标记
      data.pop ##取出url
      root = url[0, url.rindex("/")+1] ##获取当前也的根目录
      html = @dow.download_html(url)
      if html#获取网页
        # html.encoding = 'gbk'
        h = html_edcode(html)

        if /.导.师/ =~ h
          data.unshift(2)
          @number+=1
          ssp=data+ ['第1页',url]
          print @number, ssp
          file.syswrite(@number.to_s+','+array_to_str(ssp)+"\r\n")
          puts
          html.links.each do |link|
            if link.text!='我要啦免费统计'and link.text!='第1页'
                page =data+ [link.text, root+link.href]
                # @url_list.push(page) ##将新对入队列
                @number+=1
                print @number, page
                file.syswrite(@number.to_s+','+array_to_str(page)+"\r\n")
                puts
            end
          end
          next

        end
        if flag!=1
          next
        else
          html.links.each do |link|
            if link.text =~/我要啦免费统计/
            else
              # @number+=1
              page =data+ [link.text, root+link.href]
              @url_list.push(page) ##将新对入队列
              # print @number, page
              # puts
            end
          end
        end
      end
    end
  end
end
url = 'http://www.sun-ada.net/htm/06-hjcx.html'
ad = AD.new
list = ad.root_url(url)
list.each do |data|
  ad.all_url
end
# ad.all_url('http://www.sun-ada.net/htm/06-hjcn/8th/19-gongbuA.html')
