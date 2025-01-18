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
		enabled = true
	}
end

------------------------------------------------------------
-- State
------------------------------------------------------------
local registeredRmlWidgets = {}
local lastUpdate = os.clock()

------------------------------------------------------------
-- Callins
------------------------------------------------------------

function widget:Update()
	local now = os.clock()
	local timeSinceLastUpdate = now - lastUpdate
	if timeSinceLastUpdate < 1 then
		return
	end
	print("rml_autoreload widget:Update", timeSinceLastUpdate, "s")
	for name, rmlWidget in pairs(registeredRmlWidgets) do
		print("checking", name)
		local document = rmlWidget.document
		local stylesheet = rmlWidget.stylesheet
		local context = rmlWidget.context
		print("checked", document, stylesheet)
	end
	lastUpdate = now
end

function widget:Initialize()
	print("rml_autoreload widget:Initialize", lastUpdate)

	--make interfaces available to other widgets:
	WG['RmlAutoreload'] = {}
	WG['RmlAutoreload'].register = function(widget)
		print("rml_autoreload RmlAutoreload.register", widget.name)
		registeredRmlWidgets[widget.name] = widget
	end
end
