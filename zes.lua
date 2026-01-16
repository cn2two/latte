--[[
-- After loading this file in any way, the globals "UI" and "Flags" are added.
-- Documentation Below.

UI:Window({ Title: string, Size: Vector2, Open: bool, Flags: { Flags.Window } }): Window

Window:Tab({ Title: string, Flags: { Flags.Tab } })

Tab:Section({ Title: string, Flags: { Flags.Section } })

Section:Label({ Title: string })
Label:Get() -> string
Label:Set(string)

Section:Button({ Title: string }, function())

Section:Checkbox({ Title: string, Default: bool }, function(bool))
Checkbox:Get() -> bool
Checkbox:Set(bool)

Section:Slider({ Title: string, Min: number, Max: number, Default: number, Suffix: string}, function(number))
Slider:Get() -> number
Slider:Set(number)

Section:Dropdown({ Title: string, Options: { string }, Default: string }, function(string))
Dropdown:Get() -> string
Dropdown:Set(string)

Section:MultiDropdown({ Title: string, Options: { string }, Default: { string } }, function({ string }))
MultiDropdown:Get() -> { string }
MultiDropdown:Set({ string })
MultiDropdown:Add(string)
MultiDropdown:Remove(string)
MultiDropdown:Toggle(string)

Section:Keybind({ Title: string, Key: Enum.KeyCode, Flags: { Flags.Widgets.Keybind } }, function(), function(key)) -- 1st function = clicked 2nd function = key changed

]]



local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Helpers = {}
function Helpers.GetWindowSize()
	return game:GetService("Workspace").CurrentCamera.ViewportSize
end

function Helpers.GetWindowMiddle(Offset)
	if not Offset then
		Offset = Vector2.new(0, 0)
	end
	return Helpers.GetWindowSize() / 2 - Offset
end

function Helpers.GetTextBounds(Text)
	return Vector2.new(#Text.Text * Text.Size * 0.55, Text.Size)
end

function Helpers.GetTriangleBounds(Triangle)
	local A = Triangle.PointA
	local B = Triangle.PointB
	local C = Triangle.PointC

	local minX = math.min(A.X, B.X, C.X)
	local minY = math.min(A.Y, B.Y, C.Y)

	local maxX = math.max(A.X, B.X, C.X)
	local maxY = math.max(A.Y, B.Y, C.Y)

	return {
		Position = Vector2.new(minX, minY),
		Size = Vector2.new(maxX - minX, maxY - minY),
	}
end

function Helpers.GetDrawingBounds(Drawing)
	if Drawing.Type == "Square" then
		return {
			Position = Drawing.Position,
			Size = Drawing.Size,
		}
	elseif Drawing.Type == "Triangle" then
		return Helpers.GetTriangleBounds(Drawing)
	elseif Drawing.Type == "Text" then
		return {
			Position = Drawing.Position,
			Size = Helpers.GetTextBounds(Drawing),
		}
	end
	print("GetDrawingBounds, Unimplemented type:", Drawing.Type)
	return {
		Position = Vector2.new(0, 0),
		Size = Vector2.new(0, 0),
	}
end

function Helpers.IsPointInRect(Point, Position, Size)
	return Point.X >= Position.X and Point.X <= Position.X + Size.X and Point.Y >= Position.Y and Point.Y <= Position.Y + Size.Y
end

function Helpers.IsMouseInRect(Position, Size)
	return Helpers.IsPointInRect(Vector2.new(Mouse.X, Mouse.Y), Position, Size)
end

function Helpers.OnPress(Function, KeyCode)
	return UserInputService.InputBegan:Connect(function(input)
		if input.KeyCode == KeyCode then
			Function()
		end
	end)
end

function Helpers.OnRelease(Function, KeyCode)
	return UserInputService.InputEnded:Connect(function(input)
		if input.KeyCode == KeyCode then
			Function()
		end
	end)
end

function Helpers.GetKeyName(KeyCodeNumber)
	for Name, Number in Enum.KeyCode do
		if KeyCodeNumber == Number then
			return Name
		end
	end
	return "UNKNOWN"
end

function Helpers.ImplementFlags()
	local Flags = { Value = 0 }

	function Flags.Has(flag)
		return Flags.Value % (flag * 2) >= flag
	end
	function Flags.Add(flag)
		if not Flags.Has(flag) then
			Flags.Value = Flags.Value + flag
		end
	end
	function Flags.Remove(flag)
		if Flags.Has(flag) then
			Flags.Value = Flags.Value - flag
		end
	end
	function Flags.Toggle(flag)
		if Flags.Has(flag) then
			Flags.Remove(flag)
		else
			Flags.Add(flag)
		end
	end
	function Flags.Set(flag, bool)
		if bool then
			Flags.Add(flag)
		else
			Flags.Remove(flag)
		end
	end
	function Flags.Clear()
		Flags.Value = 0
	end

	return Flags
end

local References = {
	Widgets = {
		Checkbox = {},
		Slider = {},
		Dropdown = {},
		MultiDropdown = {},
	},
}

References.Get = function(reference)
	return tostring(reference.Table) .. " : " .. tostring(reference.Key)
end

References.Update = function(reference, value)
	local id = References.Get(reference)
	for _, references in References.Widgets do
		if not type(references) == "table" then
			continue
		end
		local list = references[id]
		if list then
			for _, widget in list do
				widget.Internal.Value = value
				widget.Callback(widget.Internal.Value)
			end
		end
	end
end

Flags = {
	Window = { NoMove = 2 ^ 0, NoCollapse = 2 ^ 1 },
	Tab = { Inactive = 2 ^ 0, NoScroll = 2 ^ 1 },
	Section = { Inactive = 2 ^ 0, NoCollapse = 2 ^ 1 },
	Widgets = { Label = {}, Button = {}, Checkbox = {}, Slider = {}, Dropdown = {}, MultiDropdown = {}, Keybind = { NoChange = 2 ^ 0 } },
}

UI = {}
UI.__index = UI
UI.Visible = false -- start hidden

function UI:Notify(Options) end

local Window = {}
Window.__index = Window

local Tab = {}
Tab.__index = Tab

local Section = {}
Section.__index = Section

-- <<< F1 TOGGLE START >>>
spawn(function()
	local lastPressed = false
	while true do
		wait()
		local pressed = UserInputService:IsKeyDown(Enum.KeyCode.F1)
		if pressed and not lastPressed then
			lastPressed = true
			UI.Visible = not UI.Visible -- toggle global UI state
			if UI.Windows then
				for _, window in pairs(UI.Windows) do
					if window.Tabs then
						for _, tab in pairs(window.Tabs) do
							if tab.Sections then
								for _, section in pairs(tab.Sections) do
									if section.Children then
										for _, widget in pairs(section.Children.Widgets) do
											if widget.Children and widget.Children.Drawings then
												for _, drawingData in pairs(widget.Children.Drawings) do
													if drawingData.Drawing then
														drawingData.Drawing.Visible = UI.Visible
													end
												end
											end
											if widget.Children and widget.Children.Check then
												for _, line in pairs(widget.Children.Check) do
													line.Visible = UI.Visible
												end
											end
										end
									end
								end
							end
						end
					end
				end
			end
		elseif not pressed then
			lastPressed = false
		end
	end
end)
--end

        -- line 1 ends here 
	Label.Update = function(index)
		local Length = 0
		for _index, Widget in Label.Parent.Children.Widgets do
			if index > _index then
				Length += Widget.Internal.Length
			end
		end

		local TitleBounds = Helpers.GetTextBounds(Title)
		Title.Position = Label.Parent.Children.Drawings.Top.Drawing.Position + Vector2.new(0, Label.Parent.Children.Drawings.Top.Drawing.Size.Y) + Vector2.new(4, Length + TitleBounds.Y / 2)
		Title.Text = Label.Options.Title
		Title.Color = Label.Parent.Parent.Parent.Theme.Global.Text

		Label.Internal.Length = TitleBounds.Y + Label.Parent.Parent.Parent.Theme.Global.Padding / 2
	end

	table.insert(Label.Parent.Children.Widgets, Label)
	return Label
end
function Label:Get()
	return self.Options.Title
end
function Label:Set(text)
	self.Options.Title = text
end

local Button = {}
Button._index = Button

function Section:Button(Options, Callback)
	local Button = setmetatable({}, Button)
	Button.Parent = self

	Options = Options or {}
	Options.Title = Options.Title or "No Button Title"
	Button.Callback = Callback or function() end
	Options.Flags = Options.Flags or {}

	Button.Options = Options

	Button.Flags = Helpers.ImplementFlags()

	for _, Flag in Button.Options.Flags do
		Button.Flags.Value += Flag
	end

	Button.Internal = {
		Length = 0,
	}

	Button.Children = {
		Drawings = {},
		Connections = {},
	}

	local Base = Drawing.new("Square")
	Base.Filled = true
	Base.ZIndex = -60
	Button.Children.Drawings.Base = {
		Enabled = true,
		Drawing = Base,
	}

	local Title = Drawing.new("Text")
	Title.Outline = true
	Title.ZIndex = -59
	Button.Children.Drawings.Title = {
		Enabled = true,
		Drawing = Title,
	}

	local OnPress = Helpers.OnPress(function()
		if not Button.Parent.Parent.Parent.Internal.Open or not Button.Parent.Parent.Parent.Internal.Collapsed or not Button.Parent.Internal.Collapsed or Button.Parent.Parent.Parent.Internal.SelectedTab ~= Button.Parent.Parent then
			return
		end
		if Helpers.IsMouseInRect(Base.Position, Base.Size) then
			Button.Callback()
		end
	end, Enum.KeyCode.MouseButton1)

	table.insert(Button.Children.Connections, OnPress)

	Button.Update = function(index)
		local Length = 0
		for _index, Widget in Button.Parent.Children.Widgets do
			if index > _index then
				Length += Widget.Internal.Length
			end
		end

		Title.Text = Button.Options.Title
		Title.Color = Button.Parent.Parent.Parent.Theme.Global.Text

		local TitleBounds = Helpers.GetTextBounds(Title)

		Base.Size = Vector2.new(TitleBounds.X + 4, TitleBounds.Y + 6)
		Base.Position = Button.Parent.Children.Drawings.Top.Drawing.Position + Vector2.new(0, Button.Parent.Children.Drawings.Top.Drawing.Size.Y) + Vector2.new(2, Length + Base.Size.Y / 2)
		Base.Color = Button.Parent.Parent.Parent.Theme.Global.Accent
		Base.Corner = Button.Parent.Parent.Parent.Theme.Global.Corner

		Title.Position = Base.Position + Vector2.new(6, Base.Size.Y - TitleBounds.Y) / 2

		Button.Internal.Length = Base.Size.Y + Button.Parent.Parent.Parent.Theme.Global.Padding * 1.75
	end

	table.insert(Button.Parent.Children.Widgets, Button)
	return Button
end

local Checkbox = {}
Checkbox.__index = Checkbox

function Section:Checkbox(Options, Callback)
	local Checkbox = setmetatable({}, Checkbox)
	Checkbox.Parent = self

	Options = Options or {}
	Options.Title = Options.Title or "No Checkbox Title"
	Options.Default = Options.Default or false
	Options.Reference = Options.Reference or nil
	Checkbox.Callback = Callback or function(bool) end
	Options.Flags = Options.Flags or {}

	Checkbox.Options = Options

	Checkbox.Flags = Helpers.ImplementFlags()

	for _, Flag in Checkbox.Options.Flags do
		Checkbox.Flags.Value += Flag
	end

	Checkbox.Internal = {
		Length = 0,
		Value = Options.Default,
		Reference = false,
	}

	local HasReference = type(Options.Reference) == "table" and type(Options.Reference.Table) == "table" and type(Options.Reference.Key) == "string"
	local ReferenceValue
	if HasReference then
		Checkbox.Internal.Reference = HasReference
		ReferenceValue = Options.Reference.Table[Options.Reference.Key]

		if ReferenceValue then
			Checkbox.Internal.Value = ReferenceValue
		end

		local id = References.Get(Options.Reference)
		References.Widgets.Checkbox[id] = References.Widgets.Checkbox[id] or {}
		table.insert(References.Widgets.Checkbox[id], Checkbox)
	end

	Checkbox.Callback(Checkbox.Internal.Value)

	Checkbox.Children = {
		Drawings = {},
		Connections = {},
	}

	local Base = Drawing.new("Square")
	Base.Filled = true
	Base.ZIndex = -60
	Checkbox.Children.Drawings.Base = {
		Enabled = true,
		Drawing = Base,
	}

	local CheckTop = Drawing.new("Line")
	CheckTop.Thickness = 2
	CheckTop.ZIndex = -59

	local CheckBottom = Drawing.new("Line")
	CheckBottom.Thickness = 2
	CheckBottom.ZIndex = -58

	Checkbox.Children.Check = {
		CheckTop,
		CheckBottom,
	}

	local Title = Drawing.new("Text")
	Title.Outline = true
	Title.ZIndex = -57
	Checkbox.Children.Drawings.Title = {
		Enabled = true,
		Drawing = Title,
	}

	local OnPress = Helpers.OnPress(function()
		if not Checkbox.Parent.Parent.Parent.Internal.Open or not Checkbox.Parent.Parent.Parent.Internal.Collapsed or not Checkbox.Parent.Internal.Collapsed or Checkbox.Parent.Parent.Parent.Internal.SelectedTab ~= Checkbox.Parent.Parent then
			return
		end
		if Helpers.IsMouseInRect(Base.Position, Base.Size) then
			local Value = not Checkbox.Internal.Value

			if Checkbox.Internal.Reference then
				Options.Reference.Table[Options.Reference.Key] = Value
				References.Update(Options.Reference, Value)
			else
				Checkbox.Internal.Value = Value
				Checkbox.Callback(Value)
			end
		end
	end, Enum.KeyCode.MouseButton1)

	table.insert(Checkbox.Children.Connections, OnPress)

	Checkbox.Update = function(index)
		local Length = 0
		for _index, Widget in Checkbox.Parent.Children.Widgets do
			if index > _index then
				Length += Widget.Internal.Length
			end
		end

		Title.Text = Checkbox.Options.Title
		Title.Color = Checkbox.Parent.Parent.Parent.Theme.Global.Text

		local TitleBounds = Helpers.GetTextBounds(Title)

		Base.Size = Vector2.new(TitleBounds.Y * 1.5, TitleBounds.Y * 1.5)
		Base.Position = Checkbox.Parent.Children.Drawings.Top.Drawing.Position + Vector2.new(0, Checkbox.Parent.Children.Drawings.Top.Drawing.Size.Y) + Vector2.new(2, Length + Base.Size.Y / 2)
		Base.Color = Checkbox.Parent.Parent.Parent.Theme.Global.Accent
		Base.Corner = Checkbox.Parent.Parent.Parent.Theme.Global.Corner

		CheckBottom.From = Base.Position + Vector2.new(Base.Size.X * 0.25, Base.Size.Y * 0.55)
		CheckBottom.To = Base.Position + Vector2.new(Base.Size.X * 0.45, Base.Size.Y * 0.75)

		CheckTop.From = CheckBottom.To
		CheckTop.To = Base.Position + Vector2.new(Base.Size.X * 0.75, Base.Size.Y * 0.30)

		CheckBottom.Color = Color3.fromRGB(255, 255, 255)
		CheckTop.Color = Color3.fromRGB(255, 255, 255) -- TODO possibly make this changeable

		CheckBottom.Visible = Base.Visible and Checkbox.Internal.Value
		CheckTop.Visible = Base.Visible and Checkbox.Internal.Value

		Title.Position = Vector2.new(Base.Position.X + Base.Size.X + 6, Base.Position.Y + Base.Size.Y / 2 - TitleBounds.Y / 2)

		Checkbox.Internal.Length = Base.Size.Y + Checkbox.Parent.Parent.Parent.Theme.Global.Padding * 1.5
	end

	table.insert(Checkbox.Parent.Children.Widgets, Checkbox)
	return Checkbox
end
function Checkbox:Get()
	return self.Internal.Value
end
function Checkbox:Set(bool)
	self.Internal.Value = bool
	self.Callback(bool)
end

local Slider = {}
Slider.__index = Slider

function Section:Slider(Options, Callback)
	local Slider = setmetatable({}, Slider)
	Slider.Parent = self

	Options = Options or {}
	Options.Title = Options.Title or "No Slider Title"
	Options.Min = Options.Min or 0
	Options.Max = Options.Max or 0
	Options.Step = Options.Step or 1
	Options.Suffix = Options.Suffix or ""
	Options.Reference = Options.Reference or nil
	Slider.Callback = Callback or function(number) end
	Options.Flags = Options.Flags or {}

	Slider.Options = Options

	Slider.Flags = Helpers.ImplementFlags()

	for _, Flag in Slider.Options.Flags do
		Slider.Flags.Value += Flag
	end

	Slider.Internal = {
		Length = 0,
		Value = Options.Default or Slider.Options.Min,
		Sliding = false,
		Reference = false,
	}

	local HasReference = type(Options.Reference) == "table" and type(Options.Reference.Table) == "table" and type(Options.Reference.Key) == "string"
	local ReferenceValue
	if HasReference then
		Slider.Internal.Reference = HasReference
		ReferenceValue = Options.Reference.Table[Options.Reference.Key]

		if ReferenceValue then
			Slider.Internal.Value = ReferenceValue
		end

		local id = References.Get(Options.Reference)
		References.Widgets.Slider[id] = References.Widgets.Slider[id] or {}
		table.insert(References.Widgets.Slider[id], Slider)
	end

	Slider.Callback(Slider.Internal.Value)

	Slider.Children = {
		Drawings = {},
		Connections = {},
	}

	local Base = Drawing.new("Square")
	Base.Filled = true
	Base.ZIndex = -60
	Slider.Children.Drawings.Base = {
		Enabled = true,
		Drawing = Base,
	}

	local Fill = Drawing.new("Square")
	Fill.Filled = true
	Fill.ZIndex = -59
	Slider.Children.Drawings.Fill = {
		Enabled = true,
		Drawing = Fill,
	}

	local Value = Drawing.new("Text")
	Value.Outline = true
	Value.ZIndex = -58
	Slider.Children.Drawings.Value = {
		Enabled = true,
		Drawing = Value,
	}

	local Title = Drawing.new("Text")
	Title.Outline = true
	Title.ZIndex = -57
	Slider.Children.Drawings.Title = {
		Enabled = true,
		Drawing = Title,
	}

	local OnPress = Helpers.OnPress(function()
		if not Slider.Parent.Parent.Parent.Internal.Open or not Slider.Parent.Parent.Parent.Internal.Collapsed or not Slider.Parent.Internal.Collapsed or Slider.Parent.Parent.Parent.Internal.SelectedTab ~= Slider.Parent.Parent then
			return
		end
		if Helpers.IsMouseInRect(Base.Position, Base.Size) then
			Slider.Internal.Sliding = true
		end
	end, Enum.KeyCode.MouseButton1)

	local OnRelease = Helpers.OnRelease(function()
		Slider.Internal.Sliding = false
	end, Enum.KeyCode.MouseButton1)

	table.insert(Slider.Children.Connections, OnPress)
	table.insert(Slider.Children.Connections, OnRelease)

	Slider.Update = function(index)
		local Length = 0
		for _index, Widget in Slider.Parent.Children.Widgets do
			if index > _index then
				Length += Widget.Internal.Length
			end
		end

		Base.Size = Vector2.new(Slider.Parent.Children.Drawings.Base.Drawing.Size.X - 5, 15)
		Base.Position = Slider.Parent.Children.Drawings.Top.Drawing.Position + Vector2.new(0, Slider.Parent.Children.Drawings.Top.Drawing.Size.Y) + Vector2.new(2.5, Length + Base.Size.Y / 2)
		Base.Color = Slider.Parent.Parent.Parent.Theme.Global.DarkAccent
		Base.Corner = Slider.Parent.Parent.Parent.Theme.Global.Corner

		Fill.Size = Vector2.new(Base.Size.X * math.clamp((Slider.Internal.Value - Slider.Options.Min) / (Slider.Options.Max - Slider.Options.Min), 0, 1), Base.Size.Y)
		Fill.Position = Base.Position
		Fill.Color = Slider.Parent.Parent.Parent.Theme.Global.Accent
		Fill.Corner = Slider.Parent.Parent.Parent.Theme.Global.Corner

		Value.Text = Slider.Internal.Value .. Slider.Options.Suffix .. " / " .. Slider.Options.Max .. Slider.Options.Suffix
		local ValueBounds = Helpers.GetTextBounds(Value)
		Value.Position = Base.Position + Vector2.new(Base.Size.X / 2 - ValueBounds.X / 2, Base.Size.Y / 2 - ValueBounds.Y / 2 + 1)
		Value.Color = Slider.Parent.Parent.Parent.Theme.Global.Text

		Title.Text = Slider.Options.Title
		local TitleBounds = Helpers.GetTextBounds(Value)
		Title.Position = Base.Position + Vector2.new(4, Base.Size.Y / 2 - TitleBounds.Y / 2 + 1)
		Title.Color = Slider.Parent.Parent.Parent.Theme.Global.Text

		if Slider.Internal.Sliding then
			local OldValue = Slider.Internal.Value

			local Value = tonumber(string.format("%." .. math.max(0, -math.floor(math.log10(Slider.Options.Step))) .. "f", math.clamp(math.floor((Slider.Options.Min + (Slider.Options.Max - Slider.Options.Min) * math.clamp(Mouse.X - Base.Position.X, 0, Base.Size.X) / Base.Size.X) / Slider.Options.Step + 0.5) * Slider.Options.Step, Slider.Options.Min, Slider.Options.Max)))

			if Value ~= OldValue then
				if Slider.Internal.Reference then
					Options.Reference.Table[Options.Reference.Key] = math.clamp(Value, Slider.Options.Min, Slider.Options.Max)
					References.Update(Options.Reference, math.clamp(Value, Slider.Options.Min, Slider.Options.Max))
				else
					Slider.Internal.Value = math.clamp(Value, Slider.Options.Min, Slider.Options.Max)
					Slider.Callback(math.clamp(Value, Slider.Options.Min, Slider.Options.Max))
				end
			end
		end

		Slider.Internal.Length = Base.Size.Y + Slider.Parent.Parent.Parent.Theme.Global.Padding * 1.5
	end

	table.insert(Slider.Parent.Children.Widgets, Slider)
	return Slider
end
function Slider:Get()
	return self.Internal.Value
end
function Slider:Set(number)
	if number >= self.Options.Min and number <= self.Options.Max then
		self.Internal.Value = number
		self.Callback(self.Internal.Value)
	end
end

local Dropdown = {}
Dropdown.__index = Dropdown

function Section:Dropdown(Options, Callback)
	local Dropdown = setmetatable({}, Dropdown)
	Dropdown.Parent = self

	Options = Options or {}
	Options.Title = Options.Title or "No Dropdown Title"
	Options.Options = Options.Options or { "" }
	Dropdown.Callback = Callback or function(option) end
	Options.Flags = Options.Flags or {}

	Dropdown.Options = Options

	Dropdown.Flags = Helpers.ImplementFlags()

	for _, Flag in Dropdown.Options.Flags do
		Dropdown.Flags.Value += Flag
	end

	Dropdown.Options = Options

	Dropdown.Internal = {
		Length = 0,
		Value = Options.Default or Options.Options[1],
		Open = false,
	}

	Dropdown.Callback(Dropdown.Internal.Value)

	Dropdown.Children = {
		Drawings = {},
		Connections = {},
		OptionDrawings = {},
	}

	local Base = Drawing.new("Square")
	Base.Filled = true
	Base.ZIndex = -60
	Dropdown.Children.Drawings.Base = {
		Enabled = true,
		Drawing = Base,
	}

	local Title = Drawing.new("Text")
	Title.Outline = true
	Title.ZIndex = -59
	Dropdown.Children.Drawings.Title = {
		Enabled = true,
		Drawing = Title,
	}

	for index, Option in Dropdown.Options.Options do
		local Base = Drawing.new("Square")
		Base.Filled = true
		Base.ZIndex = -55

		local Title = Drawing.new("Text")
		Title.Outline = true
		Title.ZIndex = -54

		Dropdown.Children.OptionDrawings[index] = {
			Base = Base,
			Title = Title,
		}
	end

	local OnPress = Helpers.OnPress(function()
		if not Dropdown.Parent.Parent.Parent.Internal.Open or not Dropdown.Parent.Parent.Parent.Internal.Collapsed or not Dropdown.Parent.Internal.Collapsed or Dropdown.Parent.Parent.Parent.Internal.SelectedTab ~= Dropdown.Parent.Parent then
			return
		end
		if Helpers.IsMouseInRect(Base.Position, Base.Size) then
			Dropdown.Internal.Open = not Dropdown.Internal.Open
		end
		for index, Option in Dropdown.Options.Options do
			local OptionBase = Dropdown.Children.OptionDrawings[index].Base
			if Helpers.IsMouseInRect(OptionBase.Position, OptionBase.Size) and Dropdown.Internal.Open then
				Dropdown.Internal.Value = Option
				Dropdown.Callback(Option)
			end
		end
	end, Enum.KeyCode.MouseButton1)

	table.insert(Dropdown.Children.Connections, OnPress)

	Dropdown.Update = function(index)
		local Length = 0
		for _index, Widget in Dropdown.Parent.Children.Widgets do
			if index > _index then
				Length += Widget.Internal.Length
			end
		end

		local LongestOption = 0
		for index, Option in Dropdown.Options.Options do
			local Title = Dropdown.Children.OptionDrawings[index].Title
			if Helpers.GetTextBounds(Title).X > LongestOption then
				LongestOption = Helpers.GetTextBounds(Title).X
			end
		end

		Title.Text = Dropdown.Options.Title .. ": "
		Title.Color = Dropdown.Parent.Parent.Parent.Theme.Global.Text

		LongestOption += Helpers.GetTextBounds(Title).X

		Base.Position = Dropdown.Parent.Children.Drawings.Top.Drawing.Position + Vector2.new(0, Dropdown.Parent.Children.Drawings.Top.Drawing.Size.Y + Dropdown.Parent.Parent.Parent.Theme.Global.Padding * 2) + Vector2.new(2.5, Length)
		Base.Size = Vector2.new(5 + math.max(100, LongestOption), 25)
		Base.Color = Dropdown.Parent.Parent.Parent.Theme.Global.LightBase
		Base.Corner = Dropdown.Parent.Parent.Parent.Theme.Global.Corner

		Title.Text ..= Dropdown.Internal.Value
		Title.Position = Base.Position + Vector2.new(5, Base.Size.Y / 2 - Helpers.GetTextBounds(Title).Y / 2)

		for index, Option in Dropdown.Options.Options do
			Dropdown.Children.OptionDrawings[index].Title.Text = Option
			for _index, Drawing in Dropdown.Children.OptionDrawings[index] do
				Drawing.Visible = Base.Visible and Dropdown.Internal.Open
			end
		end

		local TotalOptionLenght = 0
		if Dropdown.Internal.Open then
			for index, Option in Dropdown.Options.Options do
				local OptionBase = Dropdown.Children.OptionDrawings[index].Base
				local OptionTitle = Dropdown.Children.OptionDrawings[index].Title

				OptionBase.Size = Base.Size
				OptionBase.Position = Base.Position + Vector2.new(0, (Dropdown.Parent.Parent.Parent.Theme.Global.Padding / 2 + Base.Size.Y) * index)
				if Dropdown.Internal.Value == Option then
					OptionBase.Color = Dropdown.Parent.Parent.Parent.Theme.Global.Accent
				else
					OptionBase.Color = Dropdown.Parent.Parent.Parent.Theme.Global.DarkAccent
				end
				OptionBase.Corner = Dropdown.Parent.Parent.Parent.Theme.Global.Corner

				OptionTitle.Position = OptionBase.Position + Vector2.new(5, OptionBase.Size.Y / 2 - Helpers.GetTextBounds(OptionTitle).Y / 2)
				OptionTitle.Color = Dropdown.Parent.Parent.Parent.Theme.Global.Text

				TotalOptionLenght += OptionBase.Size.Y + Dropdown.Parent.Parent.Parent.Theme.Global.Padding / 2
			end
		end

		Dropdown.Internal.Length = TotalOptionLenght + Base.Size.Y + Dropdown.Parent.Parent.Parent.Theme.Global.Padding * 1.5
	end

	table.insert(Dropdown.Parent.Children.Widgets, Dropdown)
	return Dropdown
end
function Dropdown:Get()
	return self.Internal.Value
end
function Dropdown:Set(option)
	if table.find(self.Options.Options, option) then
		self.Internal.Value = option
		self.Callback(option)
	end
end

local MultiDropdown = {}
MultiDropdown.__index = MultiDropdown

function Section:MultiDropdown(Options, Callback)
	local MultiDropdown = setmetatable({}, MultiDropdown)
	MultiDropdown.Parent = self

	Options = Options or {}
	Options.Title = Options.Title or "No MultiDropdown Title"
	Options.Options = Options.Options or { "" }
	MultiDropdown.Callback = Callback or function(option) end
	Options.Flags = Options.Flags or {}

	MultiDropdown.Options = Options

	MultiDropdown.Flags = Helpers.ImplementFlags()

	for _, Flag in MultiDropdown.Options.Flags do
		MultiDropdown.Flags.Value += Flag
	end

	MultiDropdown.Internal = {
		Length = 0,
		Value = Options.Default or {},
		Open = false,
	}

	MultiDropdown.Callback(MultiDropdown.Internal.Value)

	MultiDropdown.Children = {
		Drawings = {},
		Connections = {},
		OptionDrawings = {},
	}

	local Base = Drawing.new("Square")
	Base.Filled = true
	Base.ZIndex = -60
	MultiDropdown.Children.Drawings.Base = {
		Enabled = true,
		Drawing = Base,
	}

	local Title = Drawing.new("Text")
	Title.Outline = true
	Title.ZIndex = -59
	MultiDropdown.Children.Drawings.Title = {
		Enabled = true,
		Drawing = Title,
	}

	for index, Option in MultiDropdown.Options.Options do
		local Base = Drawing.new("Square")
		Base.Filled = true
		Base.ZIndex = -55

		local Title = Drawing.new("Text")
		Title.Outline = true
		Title.ZIndex = -54

		MultiDropdown.Children.OptionDrawings[index] = {
			Base = Base,
			Title = Title,
		}
	end

	local OnPress = Helpers.OnPress(function()
		if not MultiDropdown.Parent.Parent.Parent.Internal.Open or not MultiDropdown.Parent.Parent.Parent.Internal.Collapsed or not MultiDropdown.Parent.Internal.Collapsed or MultiDropdown.Parent.Parent.Parent.Internal.SelectedTab ~= MultiDropdown.Parent.Parent then
			return
		end
		if Helpers.IsMouseInRect(Base.Position, Base.Size) then
			MultiDropdown.Internal.Open = not MultiDropdown.Internal.Open
		end
		for index, Option in MultiDropdown.Options.Options do
			local OptionBase = MultiDropdown.Children.OptionDrawings[index].Base
			if Helpers.IsMouseInRect(OptionBase.Position, OptionBase.Size) and MultiDropdown.Internal.Open then
				if table.find(MultiDropdown.Internal.Value, Option) then
					table.remove(MultiDropdown.Internal.Value, table.find(MultiDropdown.Internal.Value, Option))
				else
					table.insert(MultiDropdown.Internal.Value, Option)
				end
				MultiDropdown.Callback(MultiDropdown.Internal.Value)
			end
		end
	end, Enum.KeyCode.MouseButton1)

	table.insert(MultiDropdown.Children.Connections, OnPress)

	MultiDropdown.Update = function(index)
		local Length = 0
		for _index, Widget in MultiDropdown.Parent.Children.Widgets do
			if index > _index then
				Length += Widget.Internal.Length
			end
		end

		table.sort(MultiDropdown.Internal.Value, function(a, b)
			return table.find(MultiDropdown.Options.Options, a) < table.find(MultiDropdown.Options.Options, b)
		end)

		local SelectedSize = 0
		for index, Option in MultiDropdown.Internal.Value do
			local Title = MultiDropdown.Children.OptionDrawings[index].Title
			SelectedSize += Helpers.GetTextBounds({ Text = Title.Text .. ", ", Size = Title.Size, Font = Title.Font }).X
		end

		Title.Text = MultiDropdown.Options.Title .. ": "
		Title.Color = MultiDropdown.Parent.Parent.Parent.Theme.Global.Text

		SelectedSize += Helpers.GetTextBounds(Title).X

		Base.Position = MultiDropdown.Parent.Children.Drawings.Top.Drawing.Position + Vector2.new(0, MultiDropdown.Parent.Children.Drawings.Top.Drawing.Size.Y + MultiDropdown.Parent.Parent.Parent.Theme.Global.Padding * 2) + Vector2.new(2.5, Length)
		Base.Size = Vector2.new(5 + math.max(100, SelectedSize), 25)
		Base.Color = MultiDropdown.Parent.Parent.Parent.Theme.Global.LightBase
		Base.Corner = MultiDropdown.Parent.Parent.Parent.Theme.Global.Corner

		Title.Text ..= table.concat(MultiDropdown.Internal.Value, ", ")
		Title.Position = Base.Position + Vector2.new(5, Base.Size.Y / 2 - Helpers.GetTextBounds(Title).Y / 2)

		for index, Option in MultiDropdown.Options.Options do
			MultiDropdown.Children.OptionDrawings[index].Title.Text = Option
			for _index, Drawing in MultiDropdown.Children.OptionDrawings[index] do
				Drawing.Visible = Base.Visible and MultiDropdown.Internal.Open
			end
		end

		local TotalOptionLenght = 0
		if MultiDropdown.Internal.Open then
			for index, Option in MultiDropdown.Options.Options do
				local OptionBase = MultiDropdown.Children.OptionDrawings[index].Base
				local OptionTitle = MultiDropdown.Children.OptionDrawings[index].Title

				OptionBase.Size = Base.Size
				OptionBase.Position = Base.Position + Vector2.new(0, (MultiDropdown.Parent.Parent.Parent.Theme.Global.Padding / 2 + Base.Size.Y) * index)
				if table.find(MultiDropdown.Internal.Value, Option) then
					OptionBase.Color = MultiDropdown.Parent.Parent.Parent.Theme.Global.Accent
				else
					OptionBase.Color = MultiDropdown.Parent.Parent.Parent.Theme.Global.DarkAccent
				end
				OptionBase.Corner = MultiDropdown.Parent.Parent.Parent.Theme.Global.Corner

				OptionTitle.Position = OptionBase.Position + Vector2.new(5, OptionBase.Size.Y / 2 - Helpers.GetTextBounds(OptionTitle).Y / 2)
				OptionTitle.Color = MultiDropdown.Parent.Parent.Parent.Theme.Global.Text

				TotalOptionLenght += OptionBase.Size.Y + MultiDropdown.Parent.Parent.Parent.Theme.Global.Padding / 2
			end
		end

		MultiDropdown.Internal.Length = TotalOptionLenght + Base.Size.Y + MultiDropdown.Parent.Parent.Parent.Theme.Global.Padding * 1.5
	end

	table.insert(MultiDropdown.Parent.Children.Widgets, MultiDropdown)
	return MultiDropdown
end
function MultiDropdown:Get()
	return self.Internal.Value
end
function MultiDropdown:Set(options)
	for index, Option in options do
		if not table.find(self.Options.Options, Option) then
			return
		end
	end
	self.Internal.Value = options
	self.Callback(options)
end
function MultiDropdown:Add(option)
	if table.find(self.Options.Options, option) and not table.find(self.Internal.Value, option) then
		table.insert(self.Internal.Value, option)
		self.Callback(self.Internal.Value)
	end
end
function MultiDropdown:Remove(option)
	if table.find(self.Internal.Value, option) then
		table.remove(self.Internal.Value, table.find(self.Internal.Value, option))
		self.Callback(self.Internal.Value)
	end
end
function MultiDropdown:Toggle(option)
	if table.find(self.Internal.Value, option) then
		self:Remove(option)
	else
		if table.find(self.Options.Options, option) then
			table.insert(self.Internal.Value, option)
			self.Callback(self.Options.Options)
		end
	end
end

local Keybind = {}
Keybind.__index = Keybind

function Section:Keybind(Options, Callback, Changed)
	local Keybind = setmetatable({}, Keybind)
	Keybind.Parent = self

	Options = Options or {}
	Options.Title = Options.Title or "No Keybind Title"
	Options.Key = Options.Key or nil
	Keybind.Callback = Callback or function() end
	Keybind.Changed = Changed or function(keycode) end
	Options.Flags = Options.Flags or {}

	Keybind.Options = Options

	Keybind.Flags = Helpers.ImplementFlags()

	for _, Flag in Keybind.Options.Flags do
		Keybind.Flags.Value += Flag
	end

	Keybind.Internal = {
		Length = 0,
		Changing = false,
		ChangeStart = 0,
		ChangeLast = 0,
	}

	Keybind.Children = {
		Drawings = {},
		Connections = {},
	}

	local Title = Drawing.new("Text")
	Title.Outline = true
	Title.ZIndex = -60
	Keybind.Children.Drawings.Title = {
		Enabled = true,
		Drawing = Title,
	}

	local Key = Drawing.new("Text")
	Key.Outline = true
	Key.ZIndex = -60
	Keybind.Children.Drawings.Key = {
		Enabled = true,
		Drawing = Key,
	}

	local OnPress = Helpers.OnPress(function()
		if not Keybind.Parent.Parent.Parent.Internal.Open or not Keybind.Parent.Parent.Parent.Internal.Collapsed or not Keybind.Parent.Internal.Collapsed or Keybind.Parent.Parent.Parent.Internal.SelectedTab ~= Keybind.Parent.Parent then
			return
		end
		local KeyBounds = Helpers.GetDrawingBounds(Key)
		if not Keybind.Flags.Has(Flags.Widgets.Keybind.NoChange) and Helpers.IsMouseInRect(KeyBounds.Position, KeyBounds.Size) and not Keybind.Internal.Changing and (os.clock() - Keybind.Internal.ChangeLast) > (1 / 50) then
			Keybind.Internal.Changing = true
			Keybind.Internal.ChangeStart = os.clock()
		end
	end, Enum.KeyCode.MouseButton1)

	local NextInput = UserInputService.InputBegan:Connect(function(input)
		if input.KeyCode == Keybind.Options.Key then
			Keybind.Callback()
		end
		if not Keybind.Parent.Parent.Parent.Internal.Open or not Keybind.Parent.Parent.Parent.Internal.Collapsed or not Keybind.Parent.Internal.Collapsed or Keybind.Parent.Parent.Parent.Internal.SelectedTab ~= Keybind.Parent.Parent then
			Keybind.Internal.Changing = false
			return
		end
		if Keybind.Internal.Changing and (os.clock() - Keybind.Internal.ChangeStart) > (1 / 50) then
			if input.KeyCode == Enum.KeyCode.Escape then
				Keybind.Internal.Changing = false
				Keybind.Options.Key = nil
				Keybind.Changed(nil)
				return
			else
				Keybind.Internal.Changing = false
				Keybind.Internal.ChangeStart = os.clock()
				Keybind.Options.Key = input.KeyCode
				Keybind.Changed(input.KeyCode)
			end
			return
		end
	end)

	table.insert(Keybind.Children.Connections, NextInput)
	table.insert(Keybind.Children.Connections, OnPress)

	Keybind.Update = function(index)
		local Length = 0
		for _index, Widget in Keybind.Parent.Children.Widgets do
			if index > _index then
				Length += Widget.Internal.Length
			end
		end

		Title.Text = Keybind.Options.Title
		Title.Position = Keybind.Parent.Children.Drawings.Top.Drawing.Position + Vector2.new(0, Keybind.Parent.Children.Drawings.Top.Drawing.Size.Y + Keybind.Parent.Parent.Parent.Theme.Global.Padding * 2) + Vector2.new(5, Length)
		Title.Color = Keybind.Parent.Parent.Parent.Theme.Global.Text

		Key.Text = "[" .. (Keybind.Internal.Changing and "..." or Keybind.Options.Key == nil and "NONE" or Helpers.GetKeyName(Keybind.Options.Key)) .. "]"
		Key.Position = Title.Position + Vector2.new(Helpers.GetTextBounds(Title).X + 6, (Helpers.GetTextBounds(Title).Y - Helpers.GetTextBounds(Key).Y) / 2)
		Key.Color = Keybind.Parent.Parent.Parent.Theme.Global.Text

		Keybind.Internal.Length = Helpers.GetTextBounds(Title).Y + Keybind.Parent.Parent.Parent.Theme.Global.Padding * 1.25
	end

	table.insert(Keybind.Parent.Children.Widgets, Keybind)
	return Keybind
end
