function widget:GetInfo()
	return {
		name = "RmlUi AutoReload",
		desc = "Hot reloads RmlUi files when they change",
		author = "smile",
		version = "1.0",
		date = "Jan 18, 2024",
		license = "GNU GPL, v2 or later",
		handler = true,
		layer = -1, -- load before all widgets that need this tool
		enabled = false
	}
end

------------------------------------------------------------
-- State
------------------------------------------------------------

local registeredFiles = {}
local filesContent = {}
local lastUpdate = os.clock()

------------------------------------------------------------
-- Functions
------------------------------------------------------------

local function register(file, widget)
	print("rml_autoreload RmlAutoreload.register", file)
	registeredFiles[file] = {
		lastModified = os.clock(),
		widget = widget
	}
	filesContent[file] = VFS.LoadFile(file)
end

local function checkRegisteredFiles()
	local now = os.clock()
	local timeSinceLastUpdate = now - lastUpdate
	if timeSinceLastUpdate < 1 then
		return
	end
	print("rml_autoreload widget:Update", timeSinceLastUpdate, "s")

	for file, meta in pairs(registeredFiles) do
		print("checking if changed", file)
		local newContent = VFS.LoadFile(file)
		if newContent ~= filesContent[file] then
			print("reloading", file)
			registeredFiles[file] = nil
			filesContent[file] = nil
			meta.widget.Shutdown()
			meta.widget.Initialize()
			print("reloaded", file)
		end
	end
	lastUpdate = now
end

------------------------------------------------------------
-- Callins
------------------------------------------------------------

function widget:Update()
	checkRegisteredFiles()
end

function widget:Initialize()
	print("rml_autoreload widget:Initialize", lastUpdate)

	--make interfaces available to other widgets:
	WG['RmlAutoreload'] = {}
	WG['RmlAutoreload'].register = register
end
