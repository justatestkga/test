getgenv().AimPart = "Head" -- For R15 Games: {UpperTorso, LowerTorso, HumanoidRootPart, Head} | For R6 Games: {Head, Torso, HumanoidRootPart}
getgenv().AimlockKey = "q"
getgenv().AimRadius = 30 -- How far away from someones character you want to lock on at
getgenv().ThirdPerson = true 
getgenv().FirstPerson = true
getgenv().TeamCheck = false -- Check if Target is on your Team (True means it wont lock onto your teamates, false is vice versa) (Set it to false if there are no teams)
getgenv().PredictMovement = true -- Predicts if they are moving in fast velocity (like jumping) so the aimbot will go a bit faster to match their speed 
getgenv().PredictionVelocity = 7
getgenv().OldAimPart = "HumanoidRootPart"
getgenv().CheckIfJumped = true
getgenv().Multiplier = -0.27


for _, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
    if v:IsA("Script") and v.Name ~= "Health" and v.Name ~= "Sound" and v:FindFirstChild("LocalScript") then
        v:Destroy()
    end
end
game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
    repeat
        wait()
    until game.Players.LocalPlayer.Character
    char.ChildAdded:Connect(function(child)
        if child:IsA("Script") then 
            wait(0.1)
            if child:FindFirstChild("LocalScript") then
                child.LocalScript:FireServer()
            end
        end
    end)
end)

repeat wait() until game:IsLoaded()

    getgenv().Aimlock = false

    local Players, Uis, RService, SGui = game:GetService"Players", game:GetService"UserInputService", game:GetService"RunService", game:GetService"StarterGui";
    local Client, Mouse, Camera, CF, RNew, Vec3, Vec2 = Players.LocalPlayer, Players.LocalPlayer:GetMouse(), workspace.CurrentCamera, CFrame.new, Ray.new, Vector3.new, Vector2.new;
    local MousePressed, CanNotify = false, false;
    local AimlockTarget;
    local OldPre;

    getgenv().CiazwareUniversalAimbotLoaded = true

    getgenv().WorldToViewportPoint = function(P)
        return Camera:WorldToViewportPoint(P)
    end

    getgenv().WorldToScreenPoint = function(P)
        return Camera.WorldToScreenPoint(Camera, P)
    end

    getgenv().GetObscuringObjects = function(T)
        if T and T:FindFirstChild(getgenv().AimPart) and Client and Client.Character:FindFirstChild("Head") then 
            local RayPos = workspace:FindPartOnRay(RNew(
                T[getgenv().AimPart].Position, Client.Character.Head.Position)
            )
            if RayPos then return RayPos:IsDescendantOf(T) end
        end
    end

    getgenv().GetNearestTarget = function()
        -- Credits to whoever made this, i didnt make it, and my own mouse2plr function kinda sucks
        local players = {}
        local PLAYER_HOLD  = {}
        local DISTANCES = {}
        for i, v in pairs(Players:GetPlayers()) do
            if v ~= Client then
                table.insert(players, v)
            end
        end
        for i, v in pairs(players) do
            if v.Character ~= nil then
                local AIM = v.Character:FindFirstChild("Head")
                if getgenv().TeamCheck == true and v.Team ~= Client.Team then
                    local DISTANCE = (v.Character:FindFirstChild("Head").Position - game.Workspace.CurrentCamera.CFrame.p).magnitude
                    local RAY = Ray.new(game.Workspace.CurrentCamera.CFrame.p, (Mouse.Hit.p - game.Workspace.CurrentCamera.CFrame.p).unit * DISTANCE)
                    local HIT,POS = game.Workspace:FindPartOnRay(RAY, game.Workspace)
                    local DIFF = math.floor((POS - AIM.Position).magnitude)
                    PLAYER_HOLD[v.Name .. i] = {}
                    PLAYER_HOLD[v.Name .. i].dist= DISTANCE
                    PLAYER_HOLD[v.Name .. i].plr = v
                    PLAYER_HOLD[v.Name .. i].diff = DIFF
                    table.insert(DISTANCES, DIFF)
                elseif getgenv().TeamCheck == false and v.Team == Client.Team then 
                    local DISTANCE = (v.Character:FindFirstChild("Head").Position - game.Workspace.CurrentCamera.CFrame.p).magnitude
                    local RAY = Ray.new(game.Workspace.CurrentCamera.CFrame.p, (Mouse.Hit.p - game.Workspace.CurrentCamera.CFrame.p).unit * DISTANCE)
                    local HIT,POS = game.Workspace:FindPartOnRay(RAY, game.Workspace)
                    local DIFF = math.floor((POS - AIM.Position).magnitude)
                    PLAYER_HOLD[v.Name .. i] = {}
                    PLAYER_HOLD[v.Name .. i].dist= DISTANCE
                    PLAYER_HOLD[v.Name .. i].plr = v
                    PLAYER_HOLD[v.Name .. i].diff = DIFF
                    table.insert(DISTANCES, DIFF)
                end
            end
        end
        
        if unpack(DISTANCES) == nil then
            return nil
        end
        
        local L_DISTANCE = math.floor(math.min(unpack(DISTANCES)))
        if L_DISTANCE > getgenv().AimRadius then
            return nil
        end
        
        for i, v in pairs(PLAYER_HOLD) do
            if v.diff == L_DISTANCE then
                return v.plr
            end
        end
        return nil
    end

    Mouse.KeyDown:Connect(function(a)
        if not (Uis:GetFocusedTextBox()) then 
            if a == AimlockKey and AimlockTarget == nil then
                pcall(function()
                    if MousePressed ~= true then MousePressed = true end 
                    local Target;Target = GetNearestTarget()
                    if Target ~= nil then 
                        AimlockTarget = Target
                    end
                end)
            elseif a == AimlockKey and AimlockTarget ~= nil then
                if AimlockTarget ~= nil then AimlockTarget = nil end
                if MousePressed ~= false then 
                    MousePressed = false 
                end
            end
        end
    end)
    RService.RenderStepped:Connect(function()
        local AimPartOld = getgenv().OldAimPart
        if getgenv().ThirdPerson == true and getgenv().FirstPerson == true then 
            if (Camera.Focus.p - Camera.CoordinateFrame.p).Magnitude > 1 or (Camera.Focus.p - Camera.CoordinateFrame.p).Magnitude <= 1 then 
                CanNotify = true 
            else 
                CanNotify = false 
            end
        elseif getgenv().ThirdPerson == true and getgenv().FirstPerson == false then 
            if (Camera.Focus.p - Camera.CoordinateFrame.p).Magnitude > 1 then 
                CanNotify = true 
            else 
                CanNotify = false 
            end
        elseif getgenv().ThirdPerson == false and getgenv().FirstPerson == true then 
            if (Camera.Focus.p - Camera.CoordinateFrame.p).Magnitude <= 1 then 
                CanNotify = true 
            else 
                CanNotify = false 
            end
        end
        if getgenv().Aimlock == true and MousePressed == true then 
            if AimlockTarget and AimlockTarget.Character and AimlockTarget.Character:FindFirstChild(getgenv().AimPart) then 
                if getgenv().FirstPerson == true then
                    if CanNotify == true then
                        if getgenv().PredictMovement == true then 
                            Camera.CFrame = CF(Camera.CFrame.p, AimlockTarget.Character[getgenv().AimPart].Position + AimlockTarget.Character[getgenv().AimPart].Velocity/PredictionVelocity)
                        elseif getgenv().PredictMovement == false then 
                            Camera.CFrame = CF(Camera.CFrame.p, AimlockTarget.Character[getgenv().AimPart].Position)
                        end
                    end
                elseif getgenv().ThirdPerson == true then 
                    if CanNotify == true then
                        if getgenv().PredictMovement == true then 
                            Camera.CFrame = CF(Camera.CFrame.p, AimlockTarget.Character[getgenv().AimPart].Position + AimlockTarget.Character[getgenv().AimPart].Velocity/PredictionVelocity)
                        elseif getgenv().PredictMovement == false then 
                            Camera.CFrame = CF(Camera.CFrame.p, AimlockTarget.Character[getgenv().AimPart].Position)
                        end
                    end 
                end
            end
        end
        if getgenv().CheckIfJumped == true then
            if AimlockTarget.Character.Humanoid.FloorMaterial == Enum.Material.Air and AimlockTarget.Character.Humanoid.Jump == true then
                getgenv().AimPart = "RightLowerLeg"
            else
                getgenv().AimPart = AimPartOld
            end
        end
    end)




loadstring(game:HttpGet("https://raw.githubusercontent.com/angercc/test/main/.lua"))()



superhuman = false
	plr = game.Players.LocalPlayer
	mouse = plr:GetMouse()
	mouse.KeyDown:connect(function(key)
		if key == _G.Lol and superhuman == false then
			superhuman = true
			game.Players.LocalPlayer.Character.Humanoid.Name = "Humz"
			game.Players.LocalPlayer.Character.Humz.WalkSpeed = _G.Speeed
			game.Players.LocalPlayer.Character.Humz.JumpPower = 50
		elseif key == _G.Lol and superhuman == true then
			superhuman = false
			game.Players.LocalPlayer.Character.Humz.WalkSpeed = 16
			game.Players.LocalPlayer.Character.Humz.JumpPower = 50
			game.Players.LocalPlayer.Character.Humz.Name = "Humanoid"
		end
	end)



local ezlib = loadstring(game:HttpGet("https://pastebin.com/raw/2Fh9FL8c"))();
local ESP = loadstring(game:HttpGet("https://pastebin.com/raw/UCjGbGQ9"))()
local mainGUI = ezlib.create("Headshot.me");
local tab = mainGUI.newTab("Home");
local Aimbot = mainGUI.newTab("Aimbot");
local tab2 = mainGUI.newTab("Silent Aim");
local tab5 = mainGUI.newTab("ESP");
local shop = mainGUI.newTab("Animations");
local tab4 = mainGUI.newTab("Extras");





gv = false
plr = game.Players.LocalPlayer
mouse = plr:GetMouse()
mouse.KeyDown:connect(function(key)
    if key == _G.nigger and  gv == false then
        gv = true


        Aiming.Enabled = false

        ezlib.newNotif(ezlib.enum.notifType.text, "Silent Aim: Off").play(.7).delete(.7);

    elseif key == _G.nigger and gv == true then
        gv = false
        Aiming.Enabled = true
        ezlib.newNotif(ezlib.enum.notifType.text, "Silent Aim: On").play(.7).delete(.7);

    end
end)


lol = false
plr = game.Players.LocalPlayer
mouse = plr:GetMouse()
mouse.KeyDown:connect(function(key)
    if key == _G.Shitkid and  lol == false then
        lol = true


        Aiming.Enabled = false


    elseif key == _G.Shitkid and lol == true then
        lol = false
        Aiming.Enabled = true

    end
end)

Aimbot.newTitle("Aimbot");
Aimbot.newDiv();

Aimbot.newCheckbox("Enable", false, function(t)
    getgenv().Aimlock = not getgenv().Aimlock
end
)
Aimbot.newTextbox("Keybind", "Lowercase", function(state)
    AimlockKey = state
end)
Aimbot.newTitle("Settings");
Aimbot.newDiv();
Aimbot.newTextbox("Prediction", "Numbers", function(state)
    PredictionVelocity = state
end)
Aimbot.newTextbox("Radius", "Numbers", function(state)
    AimRadius = state
end)
Aimbot.newDropdown("Body Parts", "Select", {
	"Head",
	"HumanoidRootPart",
	"UpperTorso",
	"LowerTorso",
	}, function(objective)
        getgenv().AimPart = objective
        getgenv().OldAimPart = objective
    
	end)

tab.newTitle("Home");
tab.newDiv();
tab.newDesc("Thank you for choosing Headshot.me! This hub is still in development");
tab.newButton("Join Discord", function()   syn.request({
    Url = "http://127.0.0.1:6463/rpc?v=1",
    Method = "POST",
    Headers = {
        ["Content-Type"] = "application/json",
        ["Origin"] = "https://discord.com"
    },
    Body = game:GetService("HttpService"):JSONEncode({
        cmd = "INVITE_BROWSER",
        args = {
            code = "a7EMXnAU"
        },
        nonce = game:GetService("HttpService"):GenerateGUID(false)
    }),
 })
end);
tab.newDiv();


-----------------------------

tab2.newTitle("Silent Aim");
tab2.newDiv();
tab2.newCheckbox("Enable", false, function(State)
    if State then
        Aiming.Enabled = true
    else
        Aiming.Enabled = false
    end
end)

tab2.newTextbox("Notification Toggle", "Lowercase", function(state)
    _G.nigger = state
end)
tab2.newTextbox("No Notification", "Lowercase", function(state)
    _G.Shitkid = state
end)
tab2.newTitle("Customize");
tab2.newDiv();



tab2.newCheckbox("FOV Circle", false, function(State)
    if State then
        Aiming.ShowFOV = true
    else
        Aiming.ShowFOV = false
    end
	print("Toggled", value)
end)
tab2.newSlider("FOV Size", 60, 0, 300, function(Text)
    Aiming.FOV = Text
end)
tab2.newSlider("FOV Sides", 8, 3, 50, function(Text)
    Aiming.FOVSides = Text
end)


tab2.newTitle("Settings");
tab2.newDiv();

tab2.newCheckbox("Visible Check", false, function(state)

end)
tab2.newCheckbox("Auto Settings", false, function(state)

end)

tab2.newCheckbox("Crew Check", false, function(state)

end)
tab2.newCheckbox("Ground Check", false, function(state)

end)
tab2.newDropdown("Body Parts", "Select", {
	"Head",
	"HumanoidRootPart",
	"UpperTorso",
	"LowerTorso",
	}, function(state)
		Aiming.TargetPart = state
	end)

    bruh = false
	plr = game.Players.LocalPlayer
	mouse = plr:GetMouse()
	mouse.KeyDown:connect(function(key)
		if key == _G.Keyyy and bruh == false then
			bruh = true
			ESP.Enabed = false
		elseif key == _G.Keyyy and bruh == true then
			bruh = false
ESP:Toggle()
		end
	end)

    tab5.newTitle("ESP");
    tab5.newDiv();
    tab5.newCheckbox("Enable", ESP.Enabled, function(state)
        ESP.Enabled = state
    end)
    tab5.newTextbox("Keybind", "Lowercase", function(state)
        _G.Keyyy = state
    end)
    tab5.newDiv();
    
    tab5.newTitle("Settings");
    tab5.newCheckbox("Tracer", ESP.Tracers, function(state)
        ESP.Tracers = state;
    end)
    tab5.newCheckbox("Boxes", ESP.Boxes, function(state)
        ESP.Boxes = state;
    end)
    tab5.newCheckbox("Names", ESP.Names, function(state)
        ESP.Names = state;
    end)

    shop.newTitle("Animations");
    shop.newDiv();
    shop.newButton("Astronaut", function()
        local Animate = game.Players.LocalPlayer.Character.Animate
        Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=891621366"
        Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=891633237"
        Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=891667138"
        Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=891636393"
        Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=891627522"
        Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=891609353"
        Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=891617961"
    end)
    shop.newButton("Bubbly", function()
        local Animate = game.Players.LocalPlayer.Character.Animate
        Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=910004836"
        Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=910009958"
        Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=910034870"
        Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=910025107"
        Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=910016857"
        Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=910001910"
        Animate.swimidle.SwimIdle.AnimationId = "http://www.roblox.com/asset/?id=910030921"
        Animate.swim.Swim.AnimationId = "http://www.roblox.com/asset/?id=910028158"
    end)
    shop.newButton("Cartoony", function()
        local Animate = game.Players.LocalPlayer.Character.Animate
        Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=742637544"
        Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=742638445"
        Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=742640026"
        Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=742638842"
        Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=742637942"
        Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=742636889"
        Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=742637151"
    end)
    shop.newButton("Elder", function()
        local Animate = game.Players.LocalPlayer.Character.Animate
        Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=845397899"
        Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=845400520"
        Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=845403856"
        Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=845386501"
        Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=845398858"
        Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=845392038"
        Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=845396048"
    end)
    shop.newButton("Knight", function()
        local Animate = game.Players.LocalPlayer.Character.Animate
        Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=657595757"
        Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=657568135"
        Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=657552124"
        Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=657564596"
        Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=658409194"
        Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=658360781"
        Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=657600338"
    end)
    shop.newButton("Levitation", function()
        local Animate = game.Players.LocalPlayer.Character.Animate
        Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=616006778"
        Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=616008087"
        Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=616013216"
        Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=616010382"
        Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=616008936"
        Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=616003713"
        Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=616005863"
    end)
    shop.newButton("Mage", function()
        local Animate = game.Players.LocalPlayer.Character.Animate
        Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=707742142"
        Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=707855907"
        Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=707897309"
        Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=707861613"
        Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=707853694"
        Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=707826056"
        Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=707829716"
    end)
    shop.newButton("Ninja", function()
        local Animate = game.Players.LocalPlayer.Character.Animate
        Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=656117400"
        Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=656118341"
        Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=656121766"
        Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=656118852"
        Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=656117878"
        Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=656114359"
        Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=656115606"
    end)
    shop.newButton("Pirate", function()
        local Animate = game.Players.LocalPlayer.Character.Animate
        Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=750781874"
        Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=750782770"
        Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=750785693"
        Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=750783738"
        Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=750782230"
        Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=750779899"
        Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=750780242"
    end)

    shop.newButton("Robot", function()
        local Animate = game.Players.LocalPlayer.Character.Animate
        Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=616088211"
        Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=616089559"
        Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=616095330"
        Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=616091570"
        Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=616090535"
        Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=616086039"
        Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=616087089"
    end)
    shop.newButton("Stylish", function()
        local Animate = game.Players.LocalPlayer.Character.Animate
        Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=616136790"
        Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=616138447"
        Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=616146177"
        Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=616140816"
        Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=616139451"
        Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=616133594"
        Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=616134815"    end)
    shop.newButton("Superhero", function()
        local Animate = game.Players.LocalPlayer.Character.Animate
        Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=616111295"
        Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=616113536"
        Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=616122287"
        Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=616117076"
        Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=616115533"
        Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=616104706"
        Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=616108001"
    end)
    shop.newButton("Toy", function()
        local Animate = game.Players.LocalPlayer.Character.Animate
        Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=782841498"
        Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=782845736"
        Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=782843345"
        Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=782842708"
        Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=782847020"
        Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=782843869"
        Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=782846423"
    end)
    shop.newButton("Vampire", function()
        local Animate = game.Players.LocalPlayer.Character.Animate
        Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=1083445855"
        Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=1083450166"
        Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=1083473930"
        Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=1083462077"
        Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=1083455352"
        Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=1083439238"
        Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=1083443587"
    end)
    shop.newButton("Werewolf", function()
        local Animate = game.Players.LocalPlayer.Character.Animate
        Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=1083195517"
        Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=1083214717"
        Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=1083178339"
        Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=1083216690"
        Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=1083218792"
        Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=1083182000"
        Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=1083189019"
    end)
    shop.newButton("Zombie", function()
        local Animate = game.Players.LocalPlayer.Character.Animate
        Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=616158929"
        Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=616160636"
        Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=616168032"
        Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=616163682"
        Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=616161997"
        Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=616156119"
        Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=616157476"

    end)



    local runService = game:service('RunService')

	plr = game.Players.LocalPlayer
	mouse = plr:GetMouse()
	mouse.KeyDown:connect(function(key)
        if key == _G.AntiLock then
            Enabled = not Enabled
            if Enabled == true then
                repeat
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + game.Players.LocalPlayer.Character.Humanoid.MoveDirection * getgenv().Multiplier
                    runService.Stepped:wait()
                until Enabled == false
            end
        end
    end)

    local userInput = game:service('UserInputService')
    
    userInput.InputBegan:connect(function(Key)
				if Key.KeyCode == _G.Lowerr then
					Clicking = not Clicking
					if Clicking == true then
						repeat
							mouse1click()
							wait(0.001)
						until Clicking == false
					end
				end
			end)



tab4.newTitle("WalkSpeed");
tab4.newDiv();

tab4.newTextbox("Keybind", "Lowercase", function(state)
    _G.Lol = state
end)

tab4.newSlider("Speed", 16, 0, 1000, function(state)
    _G.Speeed = state
end)

tab4.newTitle("Anti Lock");
tab4.newDiv();
tab4.newTextbox("Keybind", "Lowercase", function(state)
    _G.AntiLock = state
end)
tab4.newTextbox("Speed", "0.3", function(state)
    getgenv().Multiplier = state
end)



tab4.newTitle("Others");
tab4.newDiv();
tab4.newSlider("FOV", 70, 0, 120, function(state)
    game.Workspace.Camera.FieldOfView = state

end)
tab4.newKeybind("Auto Clicker", Enum.KeyCode.T, function(state)
    _G.Lowerr = state
end)

tab4.newTitle("Accessories");
tab4.newDiv();


tab4.newButton("Headless", function()
    game.Players.LocalPlayer.Character.Head.Transparency = 1
    for i,v in pairs(game.Players.LocalPlayer.Character.Head:GetChildren()) do
    if (v:IsA("Decal")) then
    v:Destroy()
    end
    end
    end)
    
    tab4.newButton("Right Korblox", function()
        local ply = game.Players.LocalPlayer
        local chr = ply.Character
        chr.RightLowerLeg.MeshId = "902942093"
        chr.RightLowerLeg.Transparency = "1"
        chr.RightUpperLeg.MeshId = "http://www.roblox.com/asset/?id=902942096"
        chr.RightUpperLeg.TextureID = "http://roblox.com/asset/?id=902843398"
        chr.RightFoot.MeshId = "902942089"
        chr.RightFoot.Transparency = "1"
    end)


mainGUI.openTab(tab);

