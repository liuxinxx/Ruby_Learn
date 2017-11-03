# word = File.open('/Users/liuxin/Desktop/word.csv','ab+')
array = Array.new
File.open("/Users/liuxin/Desktop/awaw.csv",'r').each_line do |line|
  array = line.split("\r")
end
file = File.open('/Users/liuxin/Desktop/www.csv','ab+')
file1 = File.open('/Users/liuxin/Desktop/www_1.csv','ab+')
i = 0
array.each do |a|
  if a =~ /([0-9].*年)/
    if a =~ /[0-9],$/
      a = a[0,a.length-1]
    end

    i=i + 1
    if i>=3000
      file1.syswrite(a+"\r\n")
    else
      file.syswrite(a+"\r\n")
    end
    # ll = $&
    # p ll
    # file = File.open('/Users/liuxin/Desktop/'+ll+'.csv','ab+')
    # file.syswrite(a+"\r\n")
  end
end
