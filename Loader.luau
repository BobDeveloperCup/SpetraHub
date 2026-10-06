--// SpetraHub Loader

local Scripts = {
    {
        Name = "Prison Life",
        PlaceId = 155615604,
        ScriptURL = "https://raw.githubusercontent.com/BobDeveloperCup/SpetraHub/main/NHX-386E436C.luau"
    },
}

local CurrentPlaceId = game.PlaceId
local SelectedScript

for _, Script in ipairs(Scripts) do
    if CurrentPlaceId == Script.PlaceId then
        SelectedScript = Script
        break
    end
end

if SelectedScript then
    loadstring(game:HttpGet(SelectedScript.ScriptURL))()
else
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "SpetraHub",
        Text = "This script is not valid for this game.",
        Icon = "rbxassetid://97660768305714",
        Duration = 3
    })

    task.wait(3)
end