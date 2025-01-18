function widget:GetInfo()
	return {
		name = "File Watch Auto Reloader",
		desc = "Reload bound widget on arbitrary file change. Check usage.",
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
-- Usage
------------------------------------------------------------
---
--- Add this to the Initialize function of a widget that you want to reload when a file changes:
---
--- 	if WG.FileWatchAutoReloader then
--- 		WG.FileWatchAutoReloader.register("path/to/file.rml", widget)
--- 		WG.FileWatchAutoReloader.register("path/to/file2.rcss", widget)
--- 	end
---

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
	registeredFiles[file] = {
		lastModified = os.clock(),
		widget = widget
	}
	filesContent[file] = VFS.LoadFile(file)
end

local function checkRegisteredFiles()
	local now = os.clock()
	local timeSinceLastUpdate = now - lastUpdate
	if timeSinceLastUpdate < 1 then -- only check every second
		return
	end

	for file, meta in pairs(registeredFiles) do
		local newContent = VFS.LoadFile(file)
		if newContent ~= filesContent[file] then
			registeredFiles[file] = nil
			filesContent[file] = nil
			meta.widget.Shutdown()
			meta.widget.Initialize()
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
	--make interfaces available to other widgets:
	WG['FileWatchAutoReloader'] = {}
	WG['FileWatchAutoReloader'].register = register
end
