term.clear()
term.setCursorPos(1,1)

print("updating karelDial")

function update()
 response = http.get("https://raw.github.com/karelmikie3/karelDial/master/karelDial")
 
 rResponse = response.readAll()
 updatedKarelDial = fs.open("KarelDialDir/temp/karelDial", "w")
 updatedKarelDial.write(rResponse)
 updatedKarelDial.close()
 
 fs.delete("/karelDial")
 
 fs.copy("KarelDialDir/temp/karelDial","/karelDial")
 fs.delete("KarelDialDir/temp/karelDial")
end

update()

shell.run("/karelDial")
