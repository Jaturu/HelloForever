local addonName = ...
local MAX_LOG = 500

local function Log(fmt, ...)
	local msg = fmt:format(...)
	print(("|cff33ff99%s|r: %s"):format(addonName, msg))
	if HelloForeverDB then
		local log = HelloForeverDB.log
		log[#log + 1] = date("%Y-%m-%d %H:%M:%S ") .. msg
		while #log > MAX_LOG do
			table.remove(log, 1)
		end
	end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGIN")

frame:SetScript("OnEvent", function(self, event, arg1)
	if event == "ADDON_LOADED" and arg1 == addonName then
		HelloForeverDB = HelloForeverDB or {}
		HelloForeverDB.logins = HelloForeverDB.logins or 0
		HelloForeverDB.log = HelloForeverDB.log or {}
		self:UnregisterEvent("ADDON_LOADED")
	elseif event == "PLAYER_LOGIN" then
		HelloForeverDB.logins = HelloForeverDB.logins + 1
		Log("Hello, %s! Login #%d. Type /hello for details.", UnitName("player"), HelloForeverDB.logins)
	end
end)

SLASH_HELLOFOREVER1 = "/hello"
SlashCmdList.HELLOFOREVER = function(msg)
	if msg == "clearlog" then
		wipe(HelloForeverDB.log)
		print(addonName .. ": log cleared")
		return
	end
	local version, build, _, interface = GetBuildInfo()
	Log(
		"%s-%s | client %s (build %s) | interface %d | project id %s",
		UnitName("player"),
		GetRealmName(),
		version,
		build,
		interface,
		tostring(WOW_PROJECT_ID)
	)
end
