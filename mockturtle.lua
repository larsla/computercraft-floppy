-- mock the turtle API
fuelLevel = 101

turtle = {}
turtle['down'] = function()
  print("turtle.down()")
  fuelLevel = fuelLevel - 1
  --sleep(0.2)
  return true
end
turtle['up'] = function()
  print("turtle.up()")
  fuelLevel = fuelLevel - 1
  --sleep(0.2)
  return true
end
turtle['turnLeft'] = function()
  print("turtle.turnLeft()")
  --sleep(0.2)
  return true
end
turtle['turnRight'] = function()
  print("turtle.turnRight()")
  --sleep(0.2)
  return true
end
turtle['forward'] = function()
  -- print("turtle.forward()")
  fuelLevel = fuelLevel - 1
  sleep(0.2)
  return true
end
turtle['back'] = function()
  print("turtle.back()")
  fuelLevel = fuelLevel - 1
  --sleep(0.2)
  return true
end
turtle['dig'] = function()
  print("turtle.dig()")
  --sleep(0.2)
  return true
end
turtle['digDown'] = function()
  -- print("turtle.digDown()")
  --sleep(0.2)
  return true
end
turtle['digUp'] = function()
  -- print("turtle.digUp()")
  --sleep(0.2)
  return true
end
turtle['attack'] = function()
  -- print("turtle.attack()")
  --sleep(0.2)
  return true
end
turtle['detect'] = function()
  -- print("turtle.detect()")
  return false
end
turtle['detectUp'] = function()
  -- print("turtle.detectUp()")
  return false
end
turtle['detectDown'] = function()
  -- print("turtle.detectDown()")
  return false
end
turtle['select'] = function(i)
  -- print("turtle.select(".. i .. ")")
  return true
end
turtle['place'] = function()
  print("turtle.place()")
  --sleep(0.2)
  return true
end
turtle['drop'] = function()
  print("turtle.drop()")
  --sleep(0.2)
  return true
end
turtle['getFuelLevel'] = function()
  -- print("turtle.getFuelLevel()")
  -- print("fuelLevel: " .. fuelLevel)
  return fuelLevel
end
turtle['getItemDetail'] = function()
  -- print("turtle.getItemDetail()")
  item = {}
  item.name = "minecraft:coal"
  return item
end
turtle['refuel'] = function()
  -- print("turtle.refuel()")
  fuelLevel = fuelLevel + 50
  return true
end
