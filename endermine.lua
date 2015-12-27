-- config
local emptyInterval = 30 -- how often to empty inventory
local minHeight = 10 -- how height to dig to
local rednetAnnounce = true
local rednetProtocol = "miner"
local rednetCountProtocol = "minerCount" -- protocol to use when sending inventory count
local minFuelLevel = 100 -- if we get to this level go home

-- internal variables
local args = {...}

local x = 0
local y = 0
local size = tonumber(args[1])
local height = tonumber(args[2])
local numberOfBoxes = 1
if args[3] ~= nil then
  numberOfBoxes = tonumber(args[3])
end
local originalHeight = tonumber(args[2])
local direction = 0
local blocksSinceEmpty = 0
local items = {}

local myId = string.match(os.getComputerLabel(), '[0-9]*')

-- Include some mock APIs used during development
--include mockturtle.lua
--include mockrednet.lua

if rednetAnnounce then
  sides = {"left", "right", "top", "back"}
  for i,side in pairs(sides) do
    local status, v = pcall(function() rednet.open(side) end)
    if status then
      break
    end
  end

  rednet.broadcast(myId .. ": hello", rednetProtocol)
end

function printCoords()
  print("x: " .. x .. ", y: " .. y .. ", height: " .. height .. ", direction: " .. direction)
end

function down()
  if turtle.down() then
    height = height - 1
  end
end

function up()
  if turtle.up() then
    height = height + 1
  end
end

function turnLeft()
  turtle.turnLeft()
  if direction == 0 then
    direction = 3
  else
    direction = direction - 1
  end
end

function turnRight()
  turtle.turnRight()
  if direction == 3 then
    direction = 0
  else
    direction = direction + 1
  end
end

function forward()
  if turtle.forward() then
    if direction == 0 then
      y = y + 1
    end
    if direction == 1 then
      x = x + 1
    end
    if direction == 2 then
      y = y - 1
    end
    if direction == 3 then
      x = x - 1
    end
  else
    turtle.dig()
    turtle.attack()
    forward()
  end
  --printCoords()
  damn()
end

function backward()
  if turtle.back() then
    if direction == 0 then
      y = y - 1
    end
    if direction == 1 then
      x = x - 1
    end
    if direction == 2 then
      y = y + 1
    end
    if direction == 3 then
      x = x + 1
    end
  end
end

function dig()
  turtle.dig()
  turtle.digUp()
  turtle.digDown()
end

function placeChest()
  if turtle.detectDown() then
    backward()
    turtle.select(1)
    turtle.place()
    return true
  end
end

function emptyInventory()
  items = {} -- make sure list is empty before counting
  for i = 1,16 do
    turtle.select(i)
    item = turtle.getItemDetail()
    if item then
      if items[item.name] == nil then
        items[item.name] = 0
      end
      items[item.name] = items[item.name] + item.count
    end
    turtle.drop()
  end
  if rednetAnnounce then
    rednet.broadcast(items, rednetCountProtocol)
  end
  turtle.select(1)
end

function pickUpChest()
  turtle.select(1)
  turtle.dig()
end

function nextLevel()
  turtle.digDown()
  down()
  turtle.digDown()
  down()
end

function refuel()
  if turtle.getFuelLevel() < 500 then
    for i=1,16 do
      item = turtle.getItemDetail(i)
      if item then
        if item.name == "minecraft:coal" then
          turtle.select(i)
          turtle.refuel()
        end
      end
      if turtle.getFuelLevel() > 2000 then
        break
      end
    end
  end
  if turtle.getFuelLevel() < minFuelLevel then
    print("Out of fuel, going home")
    if rednetAnnounce then
      rednet.broadcast(myId .. ": Out of fuel, going home", rednetProtocol)
    end
    goHome()
    exit(0)
  end
end

function digLine()
  for i=0,size-2 do
    if turtle.detect() or turtle.detectUp() or turtle.detectDown() then
      dig()
      forward()
      blocksSinceEmpty = blocksSinceEmpty + 1
      if blocksSinceEmpty >= emptyInterval then
        print("time to empty inventory..")
        if placeChest() then
          emptyInventory()
          pickUpChest()
          forward()
          blocksSinceEmpty = 0
        end
      end
    else
      forward()
    end
    refuel()
  end
end

function goToZero()
  while( direction ~= 3 ) do
    turnLeft()
  end

  while( x > 0 ) do
    turtle.dig()
    forward()
    printCoords()
  end
  turnLeft()

  while( y > 0 ) do
    turtle.dig()
    forward()
    printCoords()
  end

  while( direction ~= 0 ) do
    turnRight()
  end
end

function goHome()
  while( height < originalHeight ) do
    turtle.digUp()
    up()
  end

  goToZero()
end

function damn()
  if x > size-1 or x < 0 then
    printCoords()
    if rednetAnnounce then
      rednet.broadcast(myId .. ": error!", rednetProtocol)
    end
    goHome()
    exit(0)
  end
  if y > size-1 or y < 0 then
    printCoords()
    if rednetAnnounce then
      rednet.broadcast(myId .. ": error!", rednetProtocol)
    end
    goHome()
    exit(0)
  end
end

for box=1,((numberOfBoxes-1)*size) do
  print("fast forward: " .. box)
  dig()
  turtle.forward()
end

for box=1,numberOfBoxes do
  x = 0
  y = 0

  while (height > minHeight) do
    nextLevel()
    digLine()

    stop = size-2
    for i=0,stop do
      printCoords()
      if direction == 0 or direction == 3 then
        turnRight()
        dig()
        forward()
        turnRight()
      elseif direction == 2 or direction == 1 then
        turnLeft()
        dig()
        forward()
        turnLeft()
      end
      printCoords()
      digLine()
    end
    printCoords()

    -- remove the blocks up and down when finishing level
    turtle.digUp()
    turtle.digDown()

    -- TODO: make turtle more efficient by not going back to 0/0
    goToZero()
    down()
  end

  goHome()

  if box < numberOfBoxes then
    turnLeft()
    turnLeft()
    for i=1,size do
      turtle.dig()
      turtle.forward()
    end
    turnLeft()
    turnLeft()
  end
end

-- back turtle up two blocks so we can collect it securely
turtle.back()
turtle.back()

if rednetAnnounce then
  rednet.broadcast(myId .. ": i'm done!", rednetProtocol)
end
