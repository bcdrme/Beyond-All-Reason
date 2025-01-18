function widget:GetInfo()
	return {
		name    = "Demo RML Gui",
		desc    = "A sandbox for the Rml powered GUI.",
		author  = "ChrisFloofyKitsune",
		date    = "2024-03-17",
		license = "https://unlicense.org/",
		layer   = 10,
		handler = true,
		enabled = true
	}
end

local document
local rmlContext
local eventCallback = function(ev, ...) Spring.Echo('orig function says', ...) end
local dm_handle

------------------------------------------------------------
-- Callins
------------------------------------------------------------

function widget:Initialize()
	rmlContext = RmlUi.CreateContext(widget.whInfo.name)

	-- use the DataModel handle to set values
	-- only keys declared at the DataModel's creation can be used
	dm_handle = rmlContext:OpenDataModel("data_model_test", {
		exampleValue = 'Changes when clicked',
		-- Functions inside a DataModel cannot be changed later
		-- so instead a function variable external to the DataModel is called and _that_ can be changed
		exampleEventHook = function(...) eventCallback(...) end
	});

	eventCallback = function(ev, ...)
		Spring.Echo(ev.parameters.mouse_x, ev.parameters.mouse_y, ev.parameters.button, ...)
		options = { "ow", "oof!", "stop that!", "clicking go brrrr" }
		dm_handle.exampleValue = options[math.random(1, 4)]
	end

	document = rmlContext:LoadDocument("luaui/Widgets/rml_widget_assets/simple_demo.rml", widget)
	document:ReloadStyleSheet()
	document:Show()

	if WG.RmlAutoreload then
		WG.RmlAutoreload.register("luaui/Widgets/rml_widget_assets/simple_demo.rml", widget)
		WG.RmlAutoreload.register("luaui/rml_common/styles.rcss", widget)
		WG.RmlAutoreload.register("luaui/rml_common/flow_ui.rcss", widget)
	end
end

function widget:Shutdown()
	if document then
		document:Close()
	end
	if rmlContext then
		RmlUi.RemoveContext(widget.whInfo.name)
	end
end
