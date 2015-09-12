require('Dlib')

local version = 6
local UP=Updater.new("D3ftsu/GoS/master/Common/Ekko.lua", "Common\\Ekko", version)
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
-- Ekko
if GetObjectName(GetMyHero()) == "Ekko" then
--Menu
Config = scriptConfig("Ekko", "Ekko")
Config.addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, true)
Config.addParam("W", "Use W", SCRIPT_PARAM_ONOFF, true)
Config.addParam("E", "Use E", SCRIPT_PARAM_ONOFF, true)
Config.addParam("R", "Use R", SCRIPT_PARAM_ONOFF, true)
Config.addParam("Autolvl", "Autolvl", SCRIPT_PARAM_ONOFF, false)
Config.addParam("Combo", "Combo", SCRIPT_PARAM_KEYDOWN, string.byte(" "))
--Start
OnLoop(function(myHero)
    local unit = GetCurrentTarget()
    if GetCastName(myHero, _R) == "EkkoR" then
            if Config.R then
                     if (GetCurrentHP(myHero)/GetMaxHP(myHero))<0.2 and
                    CanUseSpell(myHero, _R) == READY and IsObjectAlive(myHero) and IsInDistance(unit, 1000) then
            CastTargetSpell(myHero,_R)
            end
        end
    end
AutoIgnite()
if Config.Combo then
local unit = GetCurrentTarget()
if ValidTarget(unit, 1200) then
 
-- Q cast
        if GetCastName(myHero, _Q) == "EkkoQ" then
                local QPred = GetPredictionForPlayer(GetMyHeroPos(),unit,GetMoveSpeed(unit),1700,250,1075,50,false,true)
                        if Config.Q then
                        if CanUseSpell(myHero, _Q) == READY and QPred.HitChance == 1 then
                        CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
                        end
                end
        end
-- W Cast
    if GetCastName(myHero, _W) == "EkkoW" then
        local WPred = GetPredictionForPlayer(GetMyHeroPos(),unit,GetMoveSpeed(unit),1700,250,1600,50,false,true)
            if Config.W then
            if CanUseSpell(myHero, _W) == READY and WPred.HitChance == 1 then
            CastSkillShot(_W,WPred.PredPos.x,WPred.PredPos.y,WPred.PredPos.z)
            end
        end
    end
-- E Cast Will cast E and if im correct then GoS will click champ and Ekko will blink Cast = 325 range Blink= 425
    if GetCastName(myHero, _E) == "EkkoE" then
        local EPred = GetPredictionForPlayer(GetMyHeroPos(),unit,GetMoveSpeed(unit),1700,250,750,50,false,true)
            if Config.E then
            if CanUseSpell(myHero, _E) == READY and EPred.HitChance == 1 then
            CastSkillShot(_E,EPred.PredPos.x,EPred.PredPos.y,EPred.PredPos.z)
            end
        end
    end
-- R Cast Disabled till i manage how to Use R when low --THANKS SNOWBALL
    if GetCastName(myHero, _R) == "EkkoR" then
            if Config.R then
              local ult = (GetCastLevel(myHero,_R)*150+50)+(GetBonusAP(myHero)*1.30)
                      local EPred = GetPredictionForPlayer(GetMyHeroPos(),unit,GetMoveSpeed(unit),1700,250,325,50,false,true)
                         if CanUseSpell(myHero, _R) and IsInDistance(unit, 325) then 
            if CalcDamage(myHero, unit, ult) > GetCurrentHP(unit) then
            CastSkillShot(_R,EPred.PredPos.x,EPred.PredPos.y,EPred.PredPos.z) 
              end
            end
            end
    end
end
end
end)
function LevelUp()     

if GetLevel(myHero) == 1 then
	LevelSpell(_Q)
elseif GetLevel(myHero) == 2 then
	LevelSpell(_W)
elseif GetLevel(myHero) == 3 then
	LevelSpell(_Q)
elseif GetLevel(myHero) == 4 then
        LevelSpell(_E)
elseif GetLevel(myHero) == 5 then
        LevelSpell(_Q)
elseif GetLevel(myHero) == 6 then
	LevelSpell(_R)
elseif GetLevel(myHero) == 7 then
	LevelSpell(_Q)
elseif GetLevel(myHero) == 8 then
        LevelSpell(_E)
elseif GetLevel(myHero) == 9 then
        LevelSpell(_Q)
elseif GetLevel(myHero) == 10 then
        LevelSpell(_E)
elseif GetLevel(myHero) == 11 then
        LevelSpell(_R)
elseif GetLevel(myHero) == 12 then
        LevelSpell(_E)
elseif GetLevel(myHero) == 13 then
        LevelSpell(_E)
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
PrintChat(string.format("<font color='#1244EA'>[CloudAIO]</font> <font color='#FFFFFF'>Ekko Loaded</font>"))
end
