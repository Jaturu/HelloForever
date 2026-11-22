local wow = require("spec.helpers.wow")

describe("HelloForever", function()
	local realPrint = print

	before_each(function()
		wow.reset()
		wow.load()
	end)

	after_each(function()
		_G.print = realPrint
	end)

	it("initializes saved variables on its own ADDON_LOADED", function()
		wow.fire("ADDON_LOADED", "HelloForever")
		assert.same({ logins = 0, log = {} }, HelloForeverDB)
	end)

	it("ignores ADDON_LOADED for other addons", function()
		wow.fire("ADDON_LOADED", "SomeOtherAddon")
		assert.is_nil(HelloForeverDB)
	end)

	it("keeps existing saved variables", function()
		_G.HelloForeverDB = { logins = 7, log = { "old" } }
		wow.fire("ADDON_LOADED", "HelloForever")
		assert.equal(7, HelloForeverDB.logins)
		assert.same({ "old" }, HelloForeverDB.log)
	end)

	it("counts logins and logs a greeting", function()
		wow.fire("ADDON_LOADED", "HelloForever")
		wow.fire("PLAYER_LOGIN")
		assert.equal(1, HelloForeverDB.logins)
		assert.equal(1, #HelloForeverDB.log)
		assert.matches("Hello, Tester! Login #1%.", HelloForeverDB.log[1])
		assert.matches("^%d%d%d%d%-%d%d%-%d%d %d%d:%d%d:%d%d ", HelloForeverDB.log[1])
	end)

	it("caps the log at 500 entries, dropping the oldest", function()
		wow.fire("ADDON_LOADED", "HelloForever")
		for i = 1, 505 do
			wow.slash("")
			HelloForeverDB.log[#HelloForeverDB.log] = "entry " .. i
		end
		assert.equal(500, #HelloForeverDB.log)
		assert.equal("entry 6", HelloForeverDB.log[1])
		assert.equal("entry 505", HelloForeverDB.log[500])
	end)

	it("reports client and interface info on /hello", function()
		wow.fire("ADDON_LOADED", "HelloForever")
		wow.slash("")
		assert.matches("Tester%-Testrealm | client 12%.1%.5 %(build 70961%) | interface 120105", HelloForeverDB.log[1])
	end)

	it("clears the log on /hello clearlog", function()
		wow.fire("ADDON_LOADED", "HelloForever")
		wow.slash("")
		wow.slash("clearlog")
		assert.same({}, HelloForeverDB.log)
		assert.equal("HelloForever: log cleared", wow.printed[#wow.printed])
	end)
end)
