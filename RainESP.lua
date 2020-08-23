--[[
    Simple Wallhack for ROBLOX using ImGui Drawing class
]]
---------------------------
--- Declaring ESP table ---
---------------------------

local RainESP = {}

--------------------------
--- Defining variables ---
--------------------------

local Client = game:GetService("Players").LocalPlayer
local Camera = workspace.CurrentCamera
local ViewportPoint = Camera.WorldToViewportPoint
local Drawing = Drawing.new
local Vector2 = Vector2.new
local Vector3 = Vector3.new
local Remove = table.remove

------------------------
--- Defining offsets ---
------------------------

local HeadOffset = Vector3(0, 0.5, 0)
local LegOffset = Vector3(0, 3, 0)
local TracerOffset = Vector2(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)

---------------------
--- Function code ---
---------------------

function RainESP:new(data)
    local self = setmetatable({
        Player = data.Player,
        Character = data.Player.Character,
        BoundingBox = nil,
        Name = nil,
        Tracer = nil,
        BoxColor = data.BoxColor or fromRGB(255, 255, 255)
        FFA = data.FFA or false
    }, {__index = RainESP})

    local Player = data.Player
    local Character = self.Character
    local BoxVisible = data.BoundingBoxVisible
    local TracerVisible = data.TracerVisible
    local Text = data.Text

    if not Character then return end

    local HumanoidRootPart = Character.HumanoidRootPart
    local Head = Character.Head
    local RootPartPosition, RootPartVisibility = WorldToViewportPoint(Camera, HumanoidRootPart.Position)
    local HeadPosition = WorldToViewportPoint(Camera, Head.Position + HeadOffset)
    local LegPosition = WorldToViewportPoint(Camera, HumanoidRootPart.Position - LegOffset)
    local Visibility = (self.FFA and Player.TeamColor ~= Client.TeamColor) or (not self.FFA)

    -----------------
    --- Rendering ---
    -----------------

    -- BOX --

    local BoundingBox = Drawing("Square")
    BoundingBox.Color = self.BoxColor
    BoundingBox.Thickness = 2
    BoundingBox.Filled = false
    BoundingBox.Transparency = 0.8

    -- TRACER --

    local Tracer = Drawing("Line")
    Tracer.From = TracerOffset
    Tracer.Color = self.BoxColor
    Tracer.Thickness = 2
    Tracer.Transparency = 0.8

    -- NAME --

    local Name = Drawing("Text")
    Name.Text = Text
    Name.Size = 12
    Name.Color = self.BoxColor
    Name.Center = true
    Name.Outline = true

    ------------------
    --- Visibility ---
    ------------------
    if RootPartVisibility then
        BoundingBox.Size = Vector2(2350 / RootPartPosition.Z, HeadPosition.X - LegPosition.Y)
        BoundingBox.Position = Vector2(RootPartPosition.X - BoundingBox.Size.X / 2, RootPartPosition.Y - BoundingBox.Size.Y / 2)
        Tracer.To = Vector2(RootPartPosition.X, RootPartPosition.Y - BoundingBox.Size.Y / 2)
        Name.Position = Vector2(RootPartPosition.X, (RootPartPosition.Y + BoundingBox.Size.Y / 2) - 25)
        BoundingBox.Visible = BoxVisible and Visibility
        Tracer.Visible = TracerVisible and Visibility
        Name.VIsible = BoxVisible and Visibility
    end

    self.BoundingBox = {BoundingBox, BoxVisible}
    self.Tracer = {Tracer, TracerVisible}
    self.Name = {Name, Text}

    return self
end

function RainESP:RenderESP(Visibility)
    self.BoundingBox[2] = Visibility
end

function RainESP:RenderTracer(Visibility)
    self.Tracer[2] = Visibility
end

function RainESP:RenderText(Text)
    self.Name[2] = Text
end

function RainESP:Update()
    local Player, Character, BoundingBox, Tracer, Name = self.Player, self.Character, self.BoundingBox[1], self.Tracer[1], self.Name[1]
    local BoxVisible, TracerVisible, Text, BoxColor = self.BoundingBox[2], self.Tracer[2], self.Name[2], self.BoxColor
    local HumanoidRootPart, Head = Character:FindFirstChild("HumanoidRootPart"), Character:FindFirstChild("Head")

    if HumanoidRootPart and Head then
        local RootPartPosition, RootPartVisibility = WorldToViewportPoint(Camera, HumanoidRootPart.Position)
        local HeadPosition = WorldToViewportPoint(Camera, Head.Position + HeadOffset)
        local LegPosition = WorldToViewportPoint(Camera, HumanoidRootPart.Position - LegOffset)
        local Visibility = (self.FFA and Player.TeamColor ~= Client.TeamColor) or (not self.FFA)

        if RootPartVisibility then
            BoundingBox.Size = Vector2(2350 / RootPartPosition.Z, HeadPosition.X - LegPosition.Y)
            local BoundingBoxSize = BoundingBox.Size
            BoundingBox.Position = Vector2(RootPartPosition.X - BoundingBox.Size.X / 2, RootPartPosition.Y - BoundingBox.Size.Y / 2)
            BoundingBox.Color = BoxColor
            Tracer.To = Vector2(RootPartPosition.X, RootPartPosition.Y - BoundingBox.Size.Y / 2)
            Tracer.Color = BoxColor
            Name.Position = Vector2(RootPartPosition.X, (RootPartPosition.Y + BoundingBox.Size.Y / 2) - 25)
            Name.Text = Text
            Name.Color = BoxColor

            BoundingBox.Visible = BoxVisible and Visibility
            Tracer.Visible = TracerVisible and Visibility
            Name.Visible = Visibility
        else
            BoundingBox.Visible = false
            Tracer.Visible = false
            Name.Visible = false
        end
    end
end

function RainESP:Remove()
    self.BoundingBox[1]:Remove()
    self.Tracer[1]:Remove()
    self.Name[1]:Remove()
    function self:Update() end
end

return RainESP

