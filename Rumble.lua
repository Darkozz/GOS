require('Dlib')

local version = 6
local UP=Updater.new("D3ftsu/GoS/master/Common/Rumble.lua", "Common\\Rumble", version)
if UP.newVersion() then UP.update() end
--------------- Thanks ilovesona for this ------------------------
DelayAction(function ()
        for _, imenu in pairs(menuTable) do
                local submenu = menu.addItem(SubMenu.new(imenu.name))
                for _,subImenu in pairs(imenu) do
                        if subImenu.type == SCRIPT_PARAM_ONOFF then
                                local ggeasy = submenu.addItem(MenuBool.new(subImenu.t, subImenu.value))
                                OnLoop(function(myHero) subImenu.value = ggeasy.getValue() end)
                        elseif subImenu.type == SCRIPT_PARAM_KEYDOWN then
                                local ggeasy = submenu.addItem(MenuKeyBind.new(subImenu.t, subImenu.key))
                                OnLoop(function(myHero) subImenu.key = ggeasy.getValue(true) end)
                        elseif subImenu.type == SCRIPT_PARAM_INFO then
                                submenu.addItem(MenuSeparator.new(subImenu.t))
                        end
                end
        end
        _G.DrawMenu = function ( ... )  end
end, 1000)

myIAC = IAC()

-- Rumble Q
        if GetCastName(myHero, _Q) == "RumbleFlameThrower" then
        local QPred = GetPredictionForPlayer(GetMyHeroPos(),unit,GetMoveSpeed(unit),1700,250,600,50,false,true)
            if Config.Q then
            if CanUseSpell(myHero, _Q) == READY and IsInDistance(unit, 600) and QPred.HitChance == 1 then
            CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
            end
        end
    end
    -- Rumble E
        if GetCastName(myHero, _E) == "RumbleGrenade" then
        local EPred = GetPredictionForPlayer(GetMyHeroPos(),unit,GetMoveSpeed(unit),1700,250,850,50,true,true)
            if Config.E then
            if CanUseSpell(myHero, _E) == READY and IsInDistance(unit, 850) and EPred.HitChance == 1 then
            CastSkillShot(_E,EPred.PredPos.x,EPred.PredPos.y,EPred.PredPos.z)
            end
        end
    end
-- Rumble R
        local myorigin = GetOrigin(unit)
local mymouse = GetCastRange(myHero,_R) 
if Config.R then
 local EPred = GetPredictionForPlayer(GetMyHeroPos(),unit,GetMoveSpeed(unit),1600,250,1700,55,false,true)
if CanUseSpell(myHero, _R) == READY and IsInDistance(unit, 1700) then 
    CastSkillShot3(_R,myorigin,EPred)
end
end
        local myorigin = GetOrigin(unit)
local mymouse = GetCastRange(myHero,_R) 
if Config.R then
 local EPred = GetPredictionForPlayer(GetMyHeroPos(),unit,GetMoveSpeed(unit),1600,250,1700,55,false,true)
if CanUseSpell(myHero, _R) == READY and IsInDistance(unit, 1700) then 
    CastSkillShot3(_R,myorigin,EPred)
end
end
end
end
end)
PrintChat(string.format("<font color='#1244EA'>[CloudAIO]</font> <font color='#FFFFFF'>Rumble Loaded</font>"))
end
