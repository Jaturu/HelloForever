-- Minimal stand-ins for the WoW API used by HelloForever, for offline tests.
-- Each test calls wow.reset() and then wow.load() to get a fresh addon instance.
local wow = {}

local function newFrame()
	local frame = { events = {}, scripts = {} }
	function frame:RegisterEvent(event)
		self.events[event] = true
	end
	function frame:UnregisterEvent(event)
		self.events[event] = nil
	end
	function frame:SetScript(name, fn)
		self.scripts[name] = fn
	end
	return frame
end

function wow.reset()
	wow.frames = {}
	wow.printed = {}

	_G.HelloForeverDB = nil
	_G.SLASH_HELLOFOREVER1 = nil
	_G.SlashCmdList = {}
	_G.WOW_PROJECT_ID = 1

	_G.CreateFrame = function()
		local frame = newFrame()
		wow.frames[#wow.frames + 1] = frame
		return frame
	end
	_G.date = os.date
	_G.wipe = function(t)
		for k in pairs(t) do
			t[k] = nil
		end
		return t
	end
	_G.print = function(...)
		wow.printed[#wow.printed + 1] = table.concat({ ... }, " ")
	end
	_G.UnitName = function()
		return "Tester"
	end
	_G.GetRealmName = function()
		return "Testrealm"
	end
	_G.GetBuildInfo = function()
		return "12.1.5", "70961", "Nov 1 2026", 120105
	end
end

-- Load the addon file the way the client does: with (addonName, addonTable) as varargs.
function wow.load(addonName)
	local chunk = assert(loadfile("HelloForever.lua"))
	chunk(addonName or "HelloForever", {})
end

-- Fire an event at every registered frame.
function wow.fire(event, ...)
	for _, frame in ipairs(wow.frames) do
		if frame.events[event] and frame.scripts.OnEvent then
			frame.scripts.OnEvent(frame, event, ...)
		end
	end
end

function wow.slash(msg)
	_G.SlashCmdList.HELLOFOREVER(msg or "")
end

return wow
