
local items = {}

sides = {"left", "right", "top", "back", "bottom"}
for i,side in pairs(sides) do
  local status, v = pcall(function() rednet.open(side) end)
  if status then
    break
  end
end

monitor = peripheral.wrap("right")
monitor.clear()
monitor.setCursorPos(1,1)

local pos = 1
local length, height = monitor.getSize()

function printCount(item)
  if pos < height then
    monitor.setCursorPos(1,pos)
    monitor.write(item .. ": " .. items[item])
    pos = pos + 1
  else
    monitor.scroll(1)
    monitor.setCursorPos(1,height)
    monitor.write(item .. ": " .. items[item])
  end
end

while true do
  sender, data = rednet.receive("minerCount")
  if data then
    for k,v in pairs(data) do
      if items[k] == nil then
        items[k] = 0
      end
      items[k] = items[k] + v
      printCount(k)
    end
  end
end
