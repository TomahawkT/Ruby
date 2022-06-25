map = Hash.new{ Array.new } #|h, k| h[k] = []
map["bruzo"] = map["bruzo"].push(1)
map["bruzo"].push(2)
map["bruzo"].push(3)
map["bruzo"].push(4)
puts map
puts "----------"
map["marquinios"].push(5)
map["marquinios"].push(6)
map["marquinios"].push(7)
puts map["marquinios"]
puts "----------"
puts map["bruzo"]
puts "-------"
map["bruzo"].push(8)
map["bruzo"].push(9)
map["bruzo"].push(10)
puts map["bruzo"]