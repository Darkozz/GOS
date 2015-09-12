require('Dlib')

local version = 6
local UP=Updater.new("D3ftsu/GoS/master/Common/Fiora.lua", "Common\\Fiora", version)
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
-- Fiora
if GetObjectName(GetMyHero()) == "Fiora" then
--Menu
Config = scriptConfig("Fiora", "Fiora")
Config.addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, true)
Config.addParam("W", "Use W", SCRIPT_PARAM_ONOFF, true)
Config.addParam("E", "Use E", SCRIPT_PARAM_ONOFF, true)
Config.addParam("R", "Use R", SCRIPT_PARAM_ONOFF, true)
Config.addParam("Autolvl", "Autolvl", SCRIPT_PARAM_ONOFF, false)
Config.addParam("Combo", "Combo", SCRIPT_PARAM_KEYDOWN, string.byte(" "))
--Start
OnLoop(function(myHero)
AutoIgnite()
if Config.Combo then
local unit = GetCurrentTarget()
if ValidTarget(unit, 1550) then
                 
                 -- Fiora Q
                         if Config.Q then
        if GetCastName(myHero, _Q) == "FioraQ" then
        local QPred = GetPredictionForPlayer(GetMyHeroPos(),unit,GetMoveSpeed(unit),1700,250,400,50,false,true)
            if CanUseSpell(myHero, _Q) == READY and IsInDistance(unit, 400) then
            CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
            end
        end
    end
                     -- Fiora W
   if GetCastName(myHero, _W) == "FioraW" then
            if Config.W then
                local WPred = GetPredictionForPlayer(GetMyHeroPos(),unit,GetMoveSpeed(unit),1700,250,750,50,false,true)
                 if CanUseSpell(myHero, _W) == READY and IsObjectAlive(unit) and IsInDistance(unit, 750) then
            CastSkillShot(_W,WPred.PredPos.x,WPred.PredPos.y,WPred.PredPos.z)
            end
        end
    end
                 --Fiora E
                 if GetCastName(myHero, _E) == "FioraE" then
            if Config.E then
            if CanUseSpell(myHero, _E) == READY and IsInDistance(unit, 260) then
            CastTargetSpell(myHero,_E)
            end
        end
    end
    -- Cast R
   if GetCastName(myHero, _R) == "FioraR" then
            if Config.R then
                if (GetCurrentHP(unit)/GetMaxHP(unit))<0.4 and
                    CanUseSpell(myHero, _R) == READY and IsObjectAlive(unit) and IsInDistance(unit, 500) then
            CastTargetSpell(unit, _R)
            end
        end
    end
end
end
end)
OnProcessSpell(function(unit, spell) -- Modified Yasuo Wall Code 
  myHero = GetMyHero()
  if Config.W and unit and GetTeam(unit) ~= GetTeam(myHero) and GetObjectType(unit) == GetObjectType(myHero) and GetDistance(unit) < 1500 then
    if myHero == spell.target and spell.name:lower():find("attack") and GetRange(unit) >= 450 and CalcDamage(unit, myHero, GetBonusDmg(unit)+GetBaseDamage(unit))/GetCurrentHP(myHero) > 0.1337 then
      local wPos = GenerateWPos(GetOrigin(unit))
      CastSkillShot(_W, wPos.x, wPos.y, wPos.z)
    elseif spell.endPos then
      local makeUpPos = GenerateSpellPos(GetOrigin(unit), spell.endPos, GetDistance(unit, myHero))
      if GetDistanceSqr(makeUpPos) < (GetHitBox(myHero)*3)^2 or GetDistanceSqr(spell.endPos) < (GetHitBox(myHero)*3)^2 then
        local wPos = GenerateWPos(GetOrigin(unit))
        CastSkillShot(_W, wPos.x, wPos.y, wPos.z)
      end
    end
  end
end)
function GenerateWPos(unitPos)
    local tV = {x = (unitPos.x-GetMyHeroPos().x), z = (unitPos.z-GetMyHeroPos().z)}
    local len = math.sqrt(tV.x * tV.x + tV.z * tV.z)
    return {x = GetMyHeroPos().x + 400 * tV.x / len, y = 0, z = GetMyHeroPos().z + 400 * tV.z / len}
end

function GenerateSpellPos(unitPos, spellPos, range)
    local tV = {x = (spellPos.x-unitPos.x), z = (spellPos.z-unitPos.z)}
    local len = math.sqrt(tV.x * tV.x + tV.z * tV.z)
    return {x = unitPos.x + range * tV.x / len, y = 0, z = unitPos.z + range * tV.z / len}
end --  END of AUTOPARRY
function LevelUp()     

if GetLevel(myHero) == 1 then
	LevelSpell(_Q)
elseif GetLevel(myHero) == 2 then
	LevelSpell(_W)
elseif GetLevel(myHero) == 3 then
	LevelSpell(_E)
elseif GetLevel(myHero) == 4 then
        LevelSpell(_Q)
elseif GetLevel(myHero) == 5 then
        LevelSpell(_Q)
elseif GetLevel(myHero) == 6 then
	LevelSpell(_R)
elseif GetLevel(myHero) == 7 then
	LevelSpell(_Q)
elseif GetLevel(myHero) == 8 then
        LevelSpell(_W)
elseif GetLevel(myHero) == 9 then
        LevelSpell(_Q)
elseif GetLevel(myHero) == 10 then
        LevelSpell(_W)
elseif GetLevel(myHero) == 11 then
        LevelSpell(_R)
elseif GetLevel(myHero) == 12 then
        LevelSpell(_E)
elseif GetLevel(myHero) == 13 then
        LevelSpell(_W)
elseif GetLevel(myHero) == 14 then
        LevelSpell(_E)
elseif GetLevel(myHero) == 15 then
        LevelSpell(_W)
elseif GetLevel(myHero) == 16 then
        LevelSpell(_R)
elseif GetLevel(myHero) == 17 then
        LevelSpell(_E)
elseif GetLevel(myHero) == 18 then
        LevelSpell(_E)
end
end
PrintChat(string.format("<font color='#1244EA'>[CloudAIO]</font> <font color='#FFFFFF'>Fiora Loaded</font>"))
end
