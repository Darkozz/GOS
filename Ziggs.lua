require('Dlib')

local version = 6
local UP=Updater.new("D3ftsu/GoS/master/Common/Ziggs.lua", "Common\\Ziggs", version)
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

if GetObjectName(GetMyHero()) == "Ziggs" then
--Menu
Config = scriptConfig("Ziggs", "Ziggs")
Config.addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, true)
Config.addParam("W", "Use W", SCRIPT_PARAM_ONOFF, true)
Config.addParam("KsQ", "Use Q in KS", SCRIPT_PARAM_ONOFF, false)
Config.addParam("KsW", "Use W in KS", SCRIPT_PARAM_ONOFF, false)
Config.addParam("KsR", "Use R in KS", SCRIPT_PARAM_ONOFF, false)
Config.addParam("F", "LaneClear", SCRIPT_PARAM_ONOFF, true)
--Config.addParam("J", "JungleClear", SCRIPT_PARAM_ONOFF, true)
Config.addParam("E", "Use E", SCRIPT_PARAM_ONOFF, true)
Config.addParam("R", "Use R", SCRIPT_PARAM_ONOFF, true)
Config.addParam("H", "Use Q Harass", SCRIPT_PARAM_ONOFF, false)
Config.addParam("Z", "Use E Harass", SCRIPT_PARAM_ONOFF, false)
Config.addParam("Combo", "Combo", SCRIPT_PARAM_KEYDOWN, string.byte(" "))
LevelConfig = scriptConfig("Level", "Auto Level")
LevelConfig.addParam("L1","Max QE",SCRIPT_PARAM_ONOFF,false)
DrawingsConfig = scriptConfig("Drawings", "Drawings")
DrawingsConfig.addParam("DrawQ","Draw Q", SCRIPT_PARAM_ONOFF, true)
DrawingsConfig.addParam("DrawW","Draw W", SCRIPT_PARAM_ONOFF, true)
DrawingsConfig.addParam("DrawE","Draw E", SCRIPT_PARAM_ONOFF, true)
--Start
OnLoop(function(myHero)
AutoIgnite()
LevelUp2()
Harass2()
Killsteal2()
--LaneClear2()
--JungleClear()
 -- Ziggs Q
 if Config.Combo then
local unit = GetCurrentTarget()
if ValidTarget(unit, 1550) then
                 -- Ziggs Q

                         if Config.Q then
        if GetCastName(myHero, _Q) == "ZiggsQ" then
        local QPred = GetPredictionForPlayer(GetMyHeroPos(),unit,GetMoveSpeed(unit),1700,250,GetCastRange(myHero, _Q),50,true,true)
            if CanUseSpell(myHero, _Q) == READY and QPred.HitChance == 1  then
            CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
            end
        end
    end
        -- Ziggs E
                 if GetCastName(myHero, _E) == "ZiggsE" then
        local EPred = GetPredictionForPlayer(GetMyHeroPos(),unit,GetMoveSpeed(unit),1700,250,900,50,true,true)
            if Config.E then
            if CanUseSpell(myHero, _E) == READY and EPred.HitChance == 1 then
            CastSkillShot(_E,EPred.PredPos.x,EPred.PredPos.y,EPred.PredPos.z)
            end
        end
    end
    -- Ziggs W
   if GetCastName(myHero, _W) == "ZiggsW" then
            if Config.W then
                local WPred = GetPredictionForPlayer(GetMyHeroPos(),unit,GetMoveSpeed(unit),1700,250,5300,50,false,true)
                          if (GetCurrentHP(unit)/GetMaxHP(unit))<0.3 and
                    CanUseSpell(myHero, _W) == READY and IsObjectAlive(unit) and IsObjectAlive(myHero) and IsInDistance(unit, 1000) then
            CastSkillShot(_W,WPred.PredPos.x,WPred.PredPos.y,WPred.PredPos.z)
            end
        end
    end
-- Ziggs R
   if GetCastName(myHero, _R) == "ZiggsR" then
                 if Config.R then
        local RPred = GetPredictionForPlayer(GetMyHeroPos(),unit,GetMoveSpeed(unit),1600,250,5300,55,false,true)
        local ult = (GetCastLevel(myHero,_R)*100)+(GetBonusDmg(myHero)*1.5)
        if CanUseSpell(myHero, _R) == READY and IsInDistance(unit, 1550) then
       if CalcDamage(myHero, unit, ult) > GetCurrentHP(unit) then
        CastSkillShot(_R,RPred.PredPos.x,RPred.PredPos.y,RPred.PredPos.z)
                    end
                end
            end
    end
end
end
end)
function JungleClear2()
    for _,Q in pairs(GetAllMinions(MINION_JUNGLE)) do
          if IsInDistance(Q, 650) then
            if Config.J then
        local QPred = GetPredictionForPlayer(GetMyHeroPos(),Q,GetMoveSpeed(Q),1700,250,800,50,false,true)
            if CanUseSpell(myHero, _Q) == READY and QPred.HitChance == 1 then
            CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
            end
        end
            if Config.Y then
            if CanUseSpell(myHero, _W) == READY then
            CastTargetSpell(Obj_AI_Minion, _W)
            end
        end
-- Ziggs cast W at Enemy
        local WPred = GetPredictionForPlayer(GetMyHeroPos(),Q,GetMoveSpeed(Q),1700,250,925,50,false,true)
            if Config.Y then
            if CanUseSpell(myHero, _W) == READY and WPred.HitChance == 1 then
            CastSkillShot(_W,WPred.PredPos.x,WPred.PredPos.y,WPred.PredPos.z)
            end
end
end
end
end
function LevelUp2()     
if LevelConfig.L1 then
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
        LevelSpell(_Q)
elseif GetLevel(myHero) == 9 then
        LevelSpell(_E)
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
end
end
function Killsteal2()
local unit = GetCurrentTarget()
 if ValidTarget(unit, 1550) then
        for i,enemy in pairs(GetEnemyHeroes()) do
                          local z = ((GetCastLevel(myHero,_Q)*45)+(GetBonusAP(myHero)*1))
        local QPred = GetPredictionForPlayer(GetMyHeroPos(),unit,GetMoveSpeed(unit),1700,250,GetCastRange(myHero, _Q),50,true,true)
if CanUseSpell(myHero, _Q) == READY and ValidTarget(enemy,GetCastRange(myHero,_Q)) and Config.KsQ 
  and CalcDamage(myHero, enemy, z) > GetCurrentHP(unit) then
 CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
            end
        end
   if GetCastName(myHero, _R) == "ZiggsR" then
                 if Config.KsR then
        local RPred = GetPredictionForPlayer(GetMyHeroPos(),unit,GetMoveSpeed(unit),1600,250,5300,55,false,true)
        local ult = (GetCastLevel(myHero,_R)*100)+(GetBonusDmg(myHero)*1.5)
        if CanUseSpell(myHero, _R) == READY and IsInDistance(unit, 1550) then
       if CalcDamage(myHero, unit, ult) > GetCurrentHP(unit) then
        CastSkillShot(_R,RPred.PredPos.x,RPred.PredPos.y,RPred.PredPos.z)
                    end
                end
            end
    end
-- Ziggs cast W at Enemy
        local WPred = GetPredictionForPlayer(GetMyHeroPos(),unit,GetMoveSpeed(unit),1700,250,925,50,true,true)
            if Config.KsW then
                 local ult = (GetCastLevel(myHero,_R)*35)+(GetBonusAP(myHero)*.5)
            if CanUseSpell(myHero, _W) == READY and WPred.HitChance == 1 and CalcDamage(myHero, unit, ult) > GetCurrentHP(unit) then
            CastSkillShot(_W,WPred.PredPos.x,WPred.PredPos.y,WPred.PredPos.z)
            end
        end
end
end
function LaneClear2()
   if IWalkConfig.LaneClear then
    for _,Q in pairs(GetAllMinions(MINION_ENEMY)) do
         local EnemyPos = GetOrigin(Q)
          if IsInDistance(Q, 650) then
            if Config.F then
        local QPred = GetPredictionForPlayer(GetMyHeroPos(),Q,GetMoveSpeed(Q),1700,250,800,50,false,true)
            if CanUseSpell(myHero, _Q) == READY and (GetCurrentMana(myHero)/GetMaxMana(myHero)) > .45 then
            CastSkillShot(_Q,EnemyPos.x,EnemyPos.y,EnemyPos.z)
            end
        end
-- Ziggs cast W at Enemy
        local WPred = GetPredictionForPlayer(GetMyHeroPos(),Q,GetMoveSpeed(Q),1700,250,925,50,false,true)
            if CanUseSpell(myHero, _W) == READY and (GetCurrentMana(myHero)/GetMaxMana(myHero)) > .45 then
            CastSkillShot(_W,EnemyPos.x,EnemyPos.y,EnemyPos.z)
        end
    end
end
end
end

function Harass2()
                if IWalkConfig.Harass then
                if Config.H then
        local QPred = GetPredictionForPlayer(GetMyHeroPos(),unit,GetMoveSpeed(unit),1700,250,GetCastRange(myHero, _Q),50,true,true)
            if CanUseSpell(myHero, _Q) == READY and QPred.HitChance == 1 and (GetCurrentMana(myHero)/GetMaxMana(myHero)) > .45 then
            CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
        end
    end
    if Config.Z then
        local QPred = GetPredictionForPlayer(GetMyHeroPos(),unit,GetMoveSpeed(unit),1700,250,925,50,true,true)
            if CanUseSpell(myHero, _E) == READY and QPred.HitChance == 1 and (GetCurrentMana(myHero)/GetMaxMana(myHero)) > .45 then
            CastSkillShot(_E,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
        end
    end
end
    myHeroPos = GetOrigin(myHero)
DrawCircle(9022, 52.840878, 4360,80,1,1,0xffffffff)
DrawCircle(12060, 51, 4806,80,1,1,0xffffffff)
if CanUseSpell(myHero, _Q) == READY and DrawingsConfig.DrawQ then DrawCircle(myHeroPos.x,myHeroPos.y,myHeroPos.z,GetCastRange(myHero,_Q),3,100,0xffff00ff) end
if CanUseSpell(myHero, _E) == READY and DrawingsConfig.DrawE then DrawCircle(myHeroPos.x,myHeroPos.y,myHeroPos.z, GetCastRange(myHero,_E) ,3,100,0xffff00ff) end
if CanUseSpell(myHero, _W) == READY and DrawingsConfig.DrawW then DrawCircle(myHeroPos.x,myHeroPos.y,myHeroPos.z,GetCastRange(myHero,_W),3,100,0xffff00ff) end
PrintChat(string.format("<font color='#1244EA'>[CloudAIO]</font> <font color='#FFFFFF'>Ziggs Loaded</font>"))
end
