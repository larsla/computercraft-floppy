-- mock the rednet API

rednet = {}
rednet['open'] = function(side)
  print("mockrednet.open(".. side .. ")")
  return true
end
rednet['broadcast'] = function(message, protocol)
  print("mockrednet.broadcast(" .. message .. ", " .. protocol .. ")")
  return true
end
