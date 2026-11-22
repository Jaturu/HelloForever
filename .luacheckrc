std = "lua51"
max_line_length = 120
codes = true
exclude_files = { ".luals/", ".release/", "libs/", "Libs/" }
ignore = {
	"212/self", -- unused argument self (event handlers, mixins)
}

-- Globals this addon defines.
globals = {
	"HelloForeverDB",
	"SLASH_HELLOFOREVER1",
	"SlashCmdList",
}

-- WoW API and FrameXML globals this addon reads. Add to this list as the code grows.
read_globals = {
	"CreateFrame",
	"date",
	"GetBuildInfo",
	"GetRealmName",
	"UnitName",
	"wipe",
	"WOW_PROJECT_ID",
}

files["spec/"] = {
	std = "+busted",
	globals = { "_G", "print" },
	read_globals = { "os" },
}
