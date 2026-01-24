local Character, OnStopEvent, PlayerGui
local movesetsettings = {
	Name = "Two Time",
	Description = "hi i am two time",
}
local sourcecode = function()
	-- Character = the fake char idk
	-- OnStopEvent = fired when moveset is stopped
	-- you better clean up all the mess u made
	-- PlayerGui = hidden ui that Uhhhhhh uses
	
	-- (your random code here)
end

return {function()
	OnStopEvent = Instance.new("BindableEvent")
	PlayerGui = HiddenGUI
	local m = {}
	m.ModuleType = "MOVESET"
	m.Name = movesetsettings.Name
	m.Description = movesetsettings.Description
	m.Assets = {}
	m.Config = function(parent: GuiBase2d)
	end
	m.Init = function(figure: Model)
		Character = figure
		task.spawn(sourcecode)
	end
	m.Update = function(dt: number, figure: Model)
		-- do nothing cuz sourcecode does the stuff
	end
	m.Destroy = function(figure: Model?)
		OnStopEvent:Fire()
	end
	return m
end}