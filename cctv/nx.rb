file = File.open('/media/liuxin/python/Ruby/RubymineProjects/test.txt')
file.each_line {|line|
  line = line.gsub("\n", "")
  if line =="    "
    next
  end
  arr = line.split(',')
  str = ''
  arr[0], arr[1] = arr[1], arr[0]
  arr.each {|nn| str=str+nn+","}
  puts str.chop
}