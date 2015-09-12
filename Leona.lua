require('Dlib')

local version = 6
local UP=Updater.new("D3ftsu/GoS/master/Common/Leona.lua", "Common\\Leona", version)
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
-- Leona
if GetObjectName(GetMyHero()) == "Leona" then
--Menu
Config = scriptConfig("Leona", "Leona")
Config.addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, true)
Config.addParam("W", "Use W", SCRIPT_PARAM_ONOFF, true)
Config.addParam("E", "Use E", SCRIPT_PARAM_ONOFF, true)
Config.addParam("R", "Use R", SCRIPT_PARAM_ONOFF, true)
Config.addParam("Autolvl", "Autolvl", SCRIPT_PARAM_ONOFF, false)
Config.addParam("Combo", "Combo", SCRIPT_PARAM_KEYDOWN, string.byte(" "))
--Start
OnLoop(function(myHero)
AutoIgnite()
LeonaW()
local unit = GetCurrentTarget()
if Config.Combo then
if ValidTarget(unit, 1550) then
                 
                                                  -- Leona Q
                         if Config.Q then
        if GetCastName(myHero, _Q) == "LeonaShieldOfDaybreak" then
            if CanUseSpell(myHero, _Q) == READY and IsInDistance(unit, 625) then
                        CastTargetSpell(unit,_Q)
            end
        end
    end
                                  --Leona E 
                 if Config.E then
                 if GetCastName(myHero, _E) == "LeonaZenithBlade" then
                local EPred = GetPredictionForPlayer(GetMyHeroPos(),unit,GetMoveSpeed(unit),1700,250,GetCastRange(myHero,_E),50,false,true)
                 if CanUseSpell(myHero, _E) == READY and IsObjectAlive(unit) and IsInDistance(unit, 700)  then
            CastSkillShot(_E,EPred.PredPos.x,EPred.PredPos.y,EPred.PredPos.z)
            end
        end
    end
                     -- Leona R
                     if Config.R then
                 if GetCastName(myHero, _R) == "LeonaSolarFlare" then
                local RPred = GetPredictionForPlayer(GetMyHeroPos(),unit,GetMoveSpeed(unit),1700,250,GetCastRange(myHero,_R),50,false,true)
                if (GetCurrentHP(unit)/GetMaxHP(unit))<0.8 and
                 CanUseSpell(myHero, _R) == READY and IsObjectAlive(unit) and IsInDistance(unit, 1100) then
            CastSkillShot(_R,RPred.PredPos.x,RPred.PredPos.y,RPred.PredPos.z)
            end
        end
    end
end
end
end)
function LeonaW()
        if GetCastName(myHero, _W) == "LeonaSolarBarrier" then
            if Config.W then
                local unit = GetCurrentTarget()
                     if (GetCurrentHP(myHero)/GetMaxHP(myHero))<0.75 and
                    CanUseSpell(myHero, _W) == READY and GotBuff(myHero, "recall") == 0 then
            CastTargetSpell(myHero, _W)
            end
        end
    end
end
function LevelUp()     

if GetLevel(myHero) == 1 then
	LevelSpell(_E)
elseif GetLevel(myHero) == 2 then
	LevelSpell(_Q)
elseif GetLevel(myHero) == 3 then
	LevelSpell(_W)
elseif GetLevel(myHero) == 4 then
        LevelSpell(_E)
elseif GetLevel(myHero) == 5 then
        LevelSpell(_E)
elseif GetLevel(myHero) == 6 then
	LevelSpell(_R)
elseif GetLevel(myHero) == 7 then
	LevelSpell(_E)
elseif GetLevel(myHero) == 8 then
        LevelSpell(_Q)
elseif GetLevel(myHero) == 9 then
        LevelSpell(_E)
elseif GetLevel(myHero) == 10 then
        LevelSpell(_Q)
elseif GetLevel(myHero) == 11 then
        LevelSpell(_R)
elseif GetLevel(myHero) == 12 then
        LevelSpell(_Q)
elseif GetLevel(myHero) == 13 then
        LevelSpell(_Q)
elseif GetLevel(myHero) == 14 then
        LevelSpell(_W)
elseif GetLevel(myHero) == 15 then
        LevelSpell(_W)
elseif GetLevel(myHero) == 16 then
        LevelSpell(_R)
elseif GetLevel(myHero) == 17 then
        LevelSpell(_W)
elseif GetLevel(myHero) == 18 then
        LevelSpell(_W)
end
end
PrintChat(string.format("<font color='#1244EA'>[CloudAIO]</font> <font color='#FFFFFF'>Leona Loaded</font>"))
end
