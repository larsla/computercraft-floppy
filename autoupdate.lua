local args = { ... }

shell.run("mkdir autoupdate")

local autostart = false
if args[1] ~= nil and args[2] ~= nil then
  f = fs.open("autoupdate/" .. args[2], "w")
  f.write(args[1])
  f.close()
else
  for i, file in pairs(fs.list("autoupdate")) do
    f = fs.open("autoupdate/" .. file, "r")
    pasteId = f.readLine()

    shell.run("rm " .. file)
    shell.run("pastebin get " .. pasteId .. " " .. file)

    if file == "autostart" then
      autostart = true
    end
  end

  shell.run("autostart")
end
