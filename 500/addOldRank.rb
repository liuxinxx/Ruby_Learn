file1 = File.open("/Users/liuxin/Desktop/2017年.csv",'r')
file2 = File.open("/Users/liuxin/Desktop/2017年.csv",'r')
array1 = Array.new
file1.each_line do |line|
  p line
end