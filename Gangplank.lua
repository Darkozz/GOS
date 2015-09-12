require('Dlib')

local version = 6
local UP=Updater.new("D3ftsu/GoS/master/Common/Gangplank.lua", "Common\\Gangplank", version)
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
-- Gangplank
if GetObjectName(GetMyHero()) == "Gangplank" then
--Menu
Config = scriptConfig("Gangplank", "Gangplank")
Config.addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, true)
Config.addParam("W", "Use W", SCRIPT_PARAM_ONOFF, true)
Config.addParam("E", "Use E", SCRIPT_PARAM_ONOFF, true)
Config.addParam("R", "Use R", SCRIPT_PARAM_ONOFF, true)
Config.addParam("F", "LastHit", SCRIPT_PARAM_ONOFF, true)
Config.addParam("Autolvl", "Autolvl", SCRIPT_PARAM_ONOFF, false)
Config.addParam("Combo", "Combo", SCRIPT_PARAM_KEYDOWN, string.byte(" "))
--Start
OnLoop(function(myHero)
  local unit = GetCurrentTarget()
  --Auto heal if under or 30% HP AND ENEMY IS IN 1000 RANGE.
   if GetCastName(myHero, _W) == "GangplankW" then
            if Config.R then
                          if (GetCurrentHP(myHero)/GetMaxHP(myHero))<0.3 and
                    CanUseSpell(myHero, _W) == READY and IsObjectAlive(unit) and IsInDistance(unit, 1000) then
            CastTargetSpell(myHero, _W)
            end
        end
    end
       -- Auto R (ks)
       if GetCastName(myHero, _R) == "GangplankR" then
            if Config.R then
                                local RPred = GetPredictionForPlayer(GetMyHeroPos(),unit,GetMoveSpeed(unit),1700,250,10000,50,false,true)
                          if (GetCurrentHP(myHero)/GetMaxHP(myHero))<0.2 and
                    CanUseSpell(myHero, _R) == READY and IsObjectAlive(unit) and IsInDistance(unit, 10000) then
            CastSkillShot(_R,RPred.PredPos.x,RPred.PredPos.y,RPred.PredPos.z)
            end
        end
    end
AutoIgnite()
QFarm()
if Config.Combo then
if ValidTarget(unit, 1550) then
                 -- Gang Q

                         if Config.Q then
        if GetCastName(myHero, _Q) == "GangplankQWrapper" then
if CanUseSpell(myHero, _Q) == READY then
    CastTargetSpell(unit ,_Q)
                end
            end
        end
        -- Gangplank E
                 if GetCastName(myHero, _E) == "GangplankE" then
        local EPred = GetPredictionForPlayer(GetMyHeroPos(),unit,GetMoveSpeed(unit),1700,250,1000,50,false,true)
            if Config.E then
            if CanUseSpell(myHero, _E) == READY and EPred.HitChance == 1 then
            CastSkillShot(_E,EPred.PredPos.x,EPred.PredPos.y,EPred.PredPos.z)
            end
        end
    end
-- Gangplank R
   if GetCastName(myHero, _R) == "GangplankR" then
            if Config.R then
                local RPred = GetPredictionForPlayer(GetMyHeroPos(),unit,GetMoveSpeed(unit),1700,250,10000,50,false,true)
                     if (GetCurrentHP(unit)/GetMaxHP(unit))<0.2 and
                    CanUseSpell(myHero, _R) == READY and IsObjectAlive(unit) and IsInDistance(unit, 10000) then
            CastSkillShot(_R,RPred.PredPos.x,RPred.PredPos.y,RPred.PredPos.z)
            end
        end
    end
end
end
end)
function QFarm()
if IWalkConfig.LastHit then
      if Config.F then
      for _,Q in pairs(GetAllMinions(MINION_ENEMY)) do
        if IsInDistance(Q, 750) then
        local z = (GetCastLevel(myHero,_Q)*25)+(GetBonusDmg(myHero)*1.7)
        local hp = GetCurrentHP(Q)
        local Dmg = CalcDamage(myHero, Q, z)
        if Dmg > hp then
if CanUseSpell(myHero, _Q) == READY then
    CastTargetSpell(Q,_Q)
            end
        end
          end
        end
        end
      end
    end
	function LevelUp()     

if GetLevel(myHero) == 1 then
	LevelSpell(_Q)
elseif GetLevel(myHero) == 2 then
	LevelSpell(_E)
elseif GetLevel(myHero) == 3 then
	LevelSpell(_W)
elseif GetLevel(myHero) == 4 then
        LevelSpell(_Q)
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
PrintChat(string.format("<font color='#1244EA'>[CloudAIO]</font> <font color='#FFFFFF'>Gangplank Loaded</font>"))
end
