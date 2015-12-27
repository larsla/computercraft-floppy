local protocol = "miner"

sides = {"left", "right", "top", "back"}
for i,side in pairs(sides) do
  local status, v = pcall(function() rednet.open(side) end)
  if status then
    break
  end
end

while true do
  sender, data = rednet.receive(protocol)
  if data then
    print(data)
  end
end
