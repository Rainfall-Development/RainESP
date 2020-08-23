local RainESP = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/CriShoux/OwlHub/master/scripts/OwlESP.lua"))();

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local Client = players.LocalPlayer;
local Tracking = {};

local Remove = table.remove;
local fromRGB = Color3.fromRGB;

local BoxColor = fromRGB(255, 255, 255);
local FFA = false;

local function characterRemoving(char)
    for i, v in next, tracking do
        if v.char == char then
            v:Remove();
            Remove(tracking, i);
        end;
    end;
end;

local function characterAdded(Player)
    local Character = Player.Character
    Character:WaitForChild("HumanoidRootPart"); Character:WaitForChild("Head")
    Tracking[#Tracking + 1] = RainESP.new({
        Player = Player,
        BoxVisible = true,
        TracerVisible = true,
        Text = Player.Name,
        FFA = FFA,
        BoxColor = BoxColor
    })
end

for i, v in next, players:GetPlayers() do
    if v ~= localPlayer then
        local Character = Player.Character
        Character:WaitForChild("HumanoidRootPart"); Character:WaitForChild("Head")
        Tracking[#Tracking + 1] = RainESP.new({
            Player = Player,
            BoxVisible = true,
            TracerVisible = true,
            Text = Player.Name,
            FFA = FFA,
            BoxColor = BoxColor
        })
        end
        v.CharacterAdded:Connect(function()
            characterAdded(v)
        end)
        v.CharacterRemoving:Connect(characterRemoving)
    end
end

local function playerAdded(Player)
    Player.CharacterAdded:Connect(function()
        characterAdded(Player);
    end)
    Player.CharacterRemoving:Connect(characterRemoving);
end

Players.PlayerAdded:Connect(playerAdded);

RunService.RenderStepped:Connect(function()
    for i, v in next, Tracking do
        v:Update();
    end;
end);