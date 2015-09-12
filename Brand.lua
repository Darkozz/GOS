require('Dlib')

local version = 6
local UP=Updater.new("D3ftsu/GoS/master/Common/Brand.lua", "Common\\Brand", version)
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

-- Brand
if GetObjectName(GetMyHero()) == "Brand" then
--Menu
Config = scriptConfig("Brand", "Brand")
Config.addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, true)
Config.addParam("W", "Use W", SCRIPT_PARAM_ONOFF, true)
Config.addParam("E", "Use E", SCRIPT_PARAM_ONOFF, true)
Config.addParam("R", "Use R", SCRIPT_PARAM_ONOFF, true)
Config.addParam("Autolvl", "Autolvl", SCRIPT_PARAM_ONOFF, false)
KSConfig = scriptConfig("KS", "Killsteal:")
KSConfig.addParam("KSR", "Killsteal with R", SCRIPT_PARAM_ONOFF, true)
KSConfig.addParam("KSQ", "Killsteal with Q", SCRIPT_PARAM_ONOFF, true)
DrawingsConfig = scriptConfig("Drawings", "Drawings:")
DrawingsConfig.addParam("DrawQ","Draw Q", SCRIPT_PARAM_ONOFF, true)
DrawingsConfig.addParam("DrawW","Draw W", SCRIPT_PARAM_ONOFF, true)
DrawingsConfig.addParam("DrawE","Draw E", SCRIPT_PARAM_ONOFF, true)
DrawingsConfig.addParam("DrawR","Draw R", SCRIPT_PARAM_ONOFF, true)
Config.addParam("DMG", "DMG", SCRIPT_PARAM_ONOFF, true)
Config.addParam("Combo", "Combo", SCRIPT_PARAM_KEYDOWN, string.byte(" "))
--Start
OnLoop(function(myHero)
AutoIgnite()
Drawings()
Killsteal()
if Config.Combo then
local unit = GetCurrentTarget()
if ValidTarget(unit, 1550) then
                 
                                  --Brand E
                 if GetCastName(myHero, _E) == "BrandConflagration" then
            if Config.E then
            if CanUseSpell(myHero, _E) == READY and IsInDistance(unit, 625) then
            CastTargetSpell(unit,_E)
            end
        end
    end
                 -- Brand Q
                         if Config.Q then
        if GetCastName(myHero, _Q) == "BrandBlaze" then
        local QPred = GetPredictionForPlayer(GetMyHeroPos(),unit,GetMoveSpeed(unit),1700,250,1050,50,true,true)
            if CanUseSpell(myHero, _Q) == READY and IsInDistance(unit, 1050) and GotBuff(unit, "brandablaze") == 1 then
            CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
            end
        end
    end
                     -- Brand W
   if GetCastName(myHero, _W) == "BrandFissure" then
            if Config.W then
                local WPred = GetPredictionForPlayer(GetMyHeroPos(),unit,GetMoveSpeed(unit),1700,250,900,50,false,true)
                 if CanUseSpell(myHero, _W) == READY and IsObjectAlive(unit) and IsInDistance(unit, 900) then
            CastSkillShot(_W,WPred.PredPos.x,WPred.PredPos.y,WPred.PredPos.z)
            end
        end
    end
    -- Cast R
   if GetCastName(myHero, _R) == "BrandWildfire" then
            if Config.R then
                local ult = (GetCastLevel(myHero,_R)*100)+(GetBonusAP(myHero)*.50)
                if CalcDamage(myHero, unit, ult) > GetCurrentHP(unit) and
                    CanUseSpell(myHero, _R) == READY and IsObjectAlive(unit) and IsInDistance(unit, 750) then
            CastTargetSpell(unit, _R)
            end
        end
    end
end
end
end)

 function Killsteal()
        for i,enemy in pairs(GetEnemyHeroes()) do
           local QPred = GetPredictionForPlayer(GetMyHeroPos(),target,GetMoveSpeed(target),2000,250,1100,60,true,false)

            if CanUseSpell(myHero, _R) == READY and ValidTarget(enemy,GetCastRange(myHero,_R)) and KSConfig.KSR and GetCurrentHP(enemy) < CalcDamage(myHero, enemy, 0, (100*GetCastLevel(myHero,_R) + 50 + 0.5*(GetBonusAP(myHero)))) then
            CastTargetSpell(enemy, _R) 
            elseif CanUseSpell(myHero, _Q) == READY and QPred.HitChance == 1 and ValidTarget(target, GetCastRange(myHero,_Q)) and KSConfig.Q and GetCurrentHP(enemy) < CalcDamage(myHero, enemy, 0, (40*GetCastLevel(myHero,_Q) + 40 + 0.65*(GetBonusAP(myHero)))) then 
    CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
            end
      end
end 
 
function Drawings()
myHeroPos = GetOrigin(myHero)
if CanUseSpell(myHero, _Q) == READY and DrawingsConfig.DrawQ then DrawCircle(myHeroPos.x,myHeroPos.y,myHeroPos.z,GetCastRange(myHero,_Q),3,100,0xff00ff00) end
if CanUseSpell(myHero, _W) == READY and DrawingsConfig.DrawW then DrawCircle(myHeroPos.x,myHeroPos.y,myHeroPos.z,GetCastRange(myHero,_W),3,100,0xff00fc000) end
if CanUseSpell(myHero, _E) == READY and DrawingsConfig.DrawE then DrawCircle(myHeroPos.x,myHeroPos.y,myHeroPos.z,GetCastRange(myHero,_E),3,100,0xff00ffc0) end
if CanUseSpell(myHero, _R) == READY and DrawingsConfig.DrawR then DrawCircle(myHeroPos.x,myHeroPos.y,myHeroPos.z,GetCastRange(myHero,_R),3,100,0xff00ffd0) end
end
function LevelUp()     

if GetLevel(myHero) == 1 then
	LevelSpell(_W)
elseif GetLevel(myHero) == 2 then
	LevelSpell(_Q)
elseif GetLevel(myHero) == 3 then
	LevelSpell(_E)
elseif GetLevel(myHero) == 4 then
        LevelSpell(_W)
elseif GetLevel(myHero) == 5 then
        LevelSpell(_W)
elseif GetLevel(myHero) == 6 then
	LevelSpell(_R)
elseif GetLevel(myHero) == 7 then
	LevelSpell(_W)
elseif GetLevel(myHero) == 8 then
        LevelSpell(_Q)
elseif GetLevel(myHero) == 9 then
        LevelSpell(_W)
elseif GetLevel(myHero) == 10 then
        LevelSpell(_Q)
elseif GetLevel(myHero) == 11 then
        LevelSpell(_R)
elseif GetLevel(myHero) == 12 then
        LevelSpell(_Q)
elseif GetLevel(myHero) == 13 then
        LevelSpell(_Q)
elseif GetLevel(myHero) == 14 then
        LevelSpell(_E)
elseif GetLevel(myHero) == 15 then
        LevelSpell(_E)
elseif GetLevel(myHero) == 16 then
        LevelSpell(_R)
elseif GetLevel(myHero) == 17 then
        LevelSpell(_W)
elseif GetLevel(myHero) == 18 then
        LevelSpell(_W)
end
end
PrintChat(string.format("<font color='#1244EA'>[CloudAIO]</font> <font color='#FFFFFF'>Brand Loaded</font>"))
end
