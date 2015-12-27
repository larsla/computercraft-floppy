
function openModem()
  sides = {"left", "right", "top", "back"}
  for i,side in pairs(sides) do
    local status, v = pcall(function() rednet.open(side) end)
    if status then
      return side
    end
  end
end
