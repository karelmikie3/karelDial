-- variables 
local running = true
local tArgs = {...}
local configWL
local configGL
local configTG
local version = "beta 1.543"

-- functions
print("Karel Dial V"..tostring(versionCode))
function isInit()
 return sg.isInitiator() == "true"
end

function glasses()
 tGlasses.clear()
 box1 = tGlasses.addBox(20, 10, 200, 65,0x48db18,0.7)
 box1.setZIndex(1)
 text1 = tGlasses.addText(26,13,"this is karelDial V: "..version,0xFFFFF)
 text1.setZIndex(2)
 text2 = tGlasses.addText(26,57,"type: $$commands for all commands",0xFFFFF)
 text2.setZIndex(2)
end

function resetConfig()
 config = fs.open("KarelDialDir/config", "w")
 config.writeLine('{')
 config.writeLine('["whitelist"] = '..tostring(configWL)..",")
 config.writeLine('["greylist"] = '..tostring(configGL)..",")
 config.writeLine('["stargate"] = '.."'"..configStargate.."',")
 config.writeLine('["terminalGlasses"] = '..tostring(configTG)..",")
 config.writeLine('["TGB"] = '.."'"..configTGlasses.."',")
 config.writeLine('}')
 config.close()
end

function loadConfig()
 readConfig = fs.open("KarelDialDir/config", "r")
 configFile = readConfig.readAll()
 configRead = textutils.unserialize(configFile)
 readConfig.close()
end


function writeWhitelist(str)
 whitelist = fs.open("KarelDialDir/whitelist", "r")
 readWhitelist = whitelist.readAll()
 whitelist.close()
 tableWhitelist = textutils.unserialize(readWhitelist)
 table.insert(tableWhitelist, tostring(str))
 whitelist = fs.open("KarelDialDir/whitelist", "w")
 whitelist.writeLine('{')
 for i = 1, #tableWhitelist do
  whitelist.writeLine('"'..tableWhitelist[i]..'",')
 end
 whitelist.writeLine('}')
 whitelist.close()
 loadWhitelist()
end

function loadWhitelist()
 readWhitelist2 = fs.open("KarelDialDir/whitelist", "r")
 WhitelistFile = readWhitelist2.readAll()
 whitelistRead = textutils.unserialize(WhitelistFile)
 readWhitelist2.close()
end


function writeGreylist(str)
 greylist = fs.open("KarelDialDir/greylist", "r")
 readGreylist = greylist.readAll()
 greylist.close()
 tableGreylist = textutils.unserialize(readGreylist)
 table.insert(tableGreylist, tostring(str))
 greylist = fs.open("KarelDialDir/greylist", "w")
 greylist.writeLine('{')
 for i = 1, #tableGreylist do
  greylist.writeLine('"'..tableGreylist[i]..'",')
 end
 greylist.writeLine('}')
 greylist.close()
 loadGreylist()
end

function loadGreylist()
 readGreylist2 = fs.open("KarelDialDir/greylist", "r")
 GreylistFile = readGreylist2.readAll()
 greylistRead = textutils.unserialize(GreylistFile)
 readGreylist2.close()
end

function startLock()
 function lock() 
  while true do
   sleep(.5)
   sg.disconnect()
  end
 end
 function eventPKey()
  os.pullEvent("key")
 end
 parallel.waitForAny(lock,eventPKey)
end


-- code ------------------------------------------------
term.setCursorPos(1,1)
term.clear()




if fs.exists("KarelDialDir") == false then
 webV = http.get("https://raw.github.com/karelmikie3/karelDial/master/version")
 versionCode = webV.readAll()
 configTGlasses = 'first'
 fs.makeDir("KarelDialDir")
 print("created directory 'KarelDialDir'")
 fs.makeDir("KarelDialDir/temp")

 y = fs.open("KarelDialDir/greylist", "w")
 y.writeLine('{')
 y.writeLine('}')
 print("created greylist")
 y.close()
 configGL = false
 
 z = fs.open("KarelDialDir/whitelist", "w")
 z.writeLine('{')
 z.writeLine('}')
 z.close()
 configWL = false
 print("created whitelist")
 
 t = fs.open("KarelDialDir/config", "w")
 t.close()
 print("created config")
 print("enter the side or name from the stargate: ")
 configStargate = tostring(read())
 print("")
 
 resetConfig()
 
 elseif fs.exists("KarelDialDir") then

 print("loaded directory")

 if fs.exists("KarelDialDir/greylist") == false then
  y = fs.open("KarelDialDir/greylist", "w")
  y.writeLine('{')
  y.writeLine('}')
  print("created greylist")
  y.close()
  configGL = false
 end
 if fs.exists("KarelDialDir/whitelist") == false then
  z = fs.open("KarelDialDir/whitelist", "w")
  z.writeLine('{')
  z.writeLine('}')
  print("created whitelist")
  z.close()
  configWL = false
 end
 if fs.exists("KarelDialDir/config") == false then
  configTGlasses = 'first'
  t = fs.open("KarelDialDir/config", "w")
  t.close()
  resetConfig()
  print("created config")
  print("enter the side or name from the stargate: ")
  configStargate = tostring(read())
 end
end

loadConfig()
configWL = configRead.whitelist
configGL = configRead.greylist
configTG = configRead.terminalGlasses
configStargate = configRead.stargate
configTGlasses = configRead.TGB


loadWhitelist()
loadGreylist()
resetConfig()
loadConfig()

fs.makeDir("KarelDialDir/temp")
response = http.get("https://raw.github.com/karelmikie3/karelDial/master/updater")

updater = fs.open("KarelDialDir/updater", "w")
rResponse = response.readAll()
updater.write(rResponse)
updater.close()

response2 = http.get("https://raw.github.com/karelmikie3/karelDial/master/version")

versionNew = response2.readAll()

if tostring(versionNew) ~= version then
 print("switching to update")
 sleep(3)
 shell.run("KarelDialDir/updater")
 return
end


if configTG == nil or configRead.TGB == nil then
 write("do you wanna enable terminal glasses: ")
 answer = read()
 if answer == "yes" then
  configTG = true
  print("at what side or on what address is the TGB?")
  configTGlasses = read()
 else
  configTG = false
 end
elseif config ~= nil then
 if configTG == true then
  print("")
  print("terminal glasses are enabled")
 elseif configTG == false then
  print("")
  print("terminal glasses are disabled")
 end
end

resetConfig()
loadConfig()



print("")
print("")
if peripheral.wrap(tostring(configRead.stargate)) then
 sg = peripheral.wrap(tostring(configRead.stargate))
 print("stargate attached")
else
 error("could not wrap stargate")
end

if configTG == true then
 if peripheral.wrap(tostring(configRead.TGB)) then
  tGlasses = peripheral.wrap(tostring(configRead.TGB))
  print("terminal glasses bridge attached")
 else
  error("could not wrap terminal glasses bridge")
 end
end

if configRead.whitelist then
 print("only people that are on your whitelist are allowed to dial you")
elseif configRead.greylist then
 print("only people that are not on your greylist are allowed to dial you")
else
 print("everybody is allowed to dial you")
end

function func1()
 if tArgs[1] == "lock" then
  print("press a key to allow the computer and the portal")
  startLock()
 end
 while running do
  sleep(.1)
  print("options of main menu: 'dial', 'options', 'close', 'lock', 'leave'")
  input1 = read()
 
  if input1 == "dial" then
   write("enter an address to dial: ")
   dialAddress = string.upper(read())
   return1, errorP = pcall(sg.connect,dialAddress)
   if return1 == false then
    print(errorP)
   end
  elseif input1 == "close" then
   sg.disconnect()
  elseif input1 == "lock" then
   function lock()
    while running do
	 sleep(.5)
	 sg.disconnect()
	end
   end
   function eventPKey()
    os.pullEvent("key")
   end
   parallel.waitForAny(lock,eventPKey)
  elseif input1 == "leave" then
   term.clear()
   term.setCursorPos(1,1)
   running = false
   break
  elseif input1 == "options" then
   print("")
   print("options of options menu: 'whitelist', greylist")
   input2 = read()
   if input2 == "whitelist" then
    print("options of the whitelist menu: 'add', 'edit'")
    input3 = read()
    if input3 == "add" then
     write("person (code) you wanna add: ")
     person = read()
     writeWhitelist(person)
     print(person.." is added")
    elseif input3 == "edit" then
     shell.run("edit", "KarelDialDir/whitelist")
    end
   elseif input2 == "greylist" then
    print("options of the whitelist menu: 'add', 'edit'")
    input3 = read
	if input3 == "add" then
     write("person (code) you wanna add: ")
     person = read()
     writeWhitelist(person)
     print(person.." is added")
    elseif input3 == "edit" then
     shell.run("edit", "KarelDialDir/greylist")
	end
   end
  end
 end
end

if configRead.whitelist or configRead.greylist then
 function func2()
  if configRead.whitelist then
   while running do
    sleep(.6)
    if sg.getDialledAddress() ~= "" then
     allowed = false
     for i = 1,#whitelistRead do
      if sg.getDialledAddress() == whitelistRead[i] then
       allowed = true
      end
     end
    end
    if allowed == false and isInit() == false then
     sg.disconnect()
    end
   end
  elseif configRead.greylist then
   while running do
    sleep(.6)
    if sg.getDialledAddress() ~= "" then
     notAllowed = true
     for i = 1,#whitelistRead do
      if sg.getDialledAddress() ~= greylistRead[i] then
       notAllowed = false
	  else
	   notAllowed = true
	   break
      end
     end
    end
    if notAllowed == true and isInit() == false then
     sg.disconnect()
    end
   end
  end
 end
else
 -- ignore this, this is just for letting things behave normal
 function func2()
  iets = 342
  os.pullEvent("redstone")
 end
end

function func2Use()
 while running do
  sleep(.1)
  func2()
 end
end

if configRead.terminalGlasses then
 function func3()
  glasses()
  while running do
   sleep(.1)
   event, msg, player = os.pullEvent("chat_command")
   local argsChat = {}
   for match in string.gmatch(msg,"[^ ]+") do
    table.insert(argsChat,match)
   end
   
   if argsChat[1] == "commands" then
    text3 = tGlasses.addText(30,24,"commands: dial, disconnect, hide, show",0x4000A3)
	text3.setZIndex(2)
	sleep(3)
	text3.delete()
   elseif argsChat[1] == "dial" then
    termAddress = string.upper(tostring(argsChat[2]))
    return1,errorP = pcall(sg.connect,termAddress)
    if return1 == false then
     text3 = tGlasses.addText(1,85,"ERROR: "..errorP,0xFF0600)
	 text3.setScale(1.5)
     text3.setZIndex(2)
	 sleep(3)
	 text3.delete()
    end
   elseif argsChat[1] == "disconnect" then
    sg.disconnect()
   elseif argsChat[1] == "hide" then
    tGlasses.clear()
   elseif argsChat[1] == "show" then
    glasses()
   end
  end
 end 
else
 function func3()
  iets = 342
  os.pullEvent("redstone")
 end
end

function func4()
 iets = 342
 os.pullEvent("redstone")
end

function funcpar1()
 while running do
 parallel.waitForAny(func1, func2)
 sleep(.6)
 end
end

function funcpar2()
 while running do
 parallel.waitForAny(func3, func4)
 sleep(.6)
 end
end

while running do
 sleep(.1)
 parallel.waitForAny(funcpar1, funcpar2)
end
