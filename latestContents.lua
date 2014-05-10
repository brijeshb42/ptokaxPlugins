require("sqlite3")

local db,insert_data, tempUser

latest_content_table = "latest"
create_table = "CREATE TABLE IF NOT EXISTS "..latest_content_table.." (id INTEGER PRIMARY KEY NOT NULL ,user TEXT,content TEXT)"
get_stmt = "SELECT * FROM "..latest_content_table.." ORDER BY id DESC LIMIT 10"
insert_stmt = "INSERT INTO "..latest_content_table.." (user,content) VALUES(?,?)"

db = sqlite3.open("latest-content.db")

function getLatestData()
	local latest = "";
	for row in db:rows(get_stmt) do
		latest = latest.."\n[id="..row.id.."] "..row.content.." by "..row.user..""
	end
	return latest.."\n===================================================\n\n"
end

function saveLatestData(data,user)
	db:exec("INSERT INTO "..latest_content_table.." (user,content) VALUES (\""..user.."\",\""..data.."\")")
end

function MyINFOArrival(tUser, sData)
	Core.SendPmToUser(tUser,"LatestContentBotINFO","\n\nLatest Contents:\n==============================================\n"..getLatestData())
end

function UserConnected(tUser,sData)
	Core.SendPmToUser(tUser,"LatestContentBot","\n\nLatest Contents:\n==============================================\n"..getLatestData())
end

function deleteData(id)
	db:exec("DELETE FROM "..latest_content_table.." WHERE id="..id)
end

function OnStartup()
	--db = sqlite3.open("latest-content.db")
	insert_data = db:prepare(insert_stmt)
	db:exec(create_table)
end

function OnExit()
	db:close()
end

function ChatArrival(tUser, sData)
	sData = string.lower(sData)
	if (string.find(sData, "+latest", 1, 1)) then
		Core.SendToUser(tUser,"\n\nLatest Contents:\n==============================================\n"..getLatestData())
		return true
	end
	if (string.find(sData,"+clear",1,1)) then
		Core.SendToUser(tUser,"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n.")
		return true
	end
	if (string.find(sData,"+delete",1,1)) then
		if (tUser.iProfile==0) then
			s,e = string.find(sData,"+delete",1,1)
			id = string.sub(sData,e+1,string.len(sData)-1)
			deleteData(id)
			Core.SendToUser(tUser,id.."")
			return true
		end
		Core.SendToUser(tUser,"You cannot perform this operation.")
		return true
	end
	if (string.find(sData, "+share ", 1, 1)) then
		s,e = string.find(sData, "+share ", 1, 1)
		dat = string.sub(sData,e+1,string.len(sData)-1)
		if (string.len(dat)>=5) then
			saveLatestData(dat,tUser.sNick)
			Core.SendToAll(tUser.sNick.." shared "..dat.."")
			return true
		end
	end
	if (string.find(sData,"+",1,1)) then
		Core.SendToUser(tUser,"\n\nSend\n+latest to get latest contents.\n+share <filename> to share latest contents.\n+clear to clear your chat.\n\n\n")
		return true
	end
end
