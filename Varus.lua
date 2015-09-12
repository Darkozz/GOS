require('Dlib')

local version = 6
local UP=Updater.new("D3ftsu/GoS/master/Common/Varus.lua", "Common\\Varus", version)
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
if GetObjectName(GetMyHero()) == "Varus" then
--Menu
Config = scriptConfig("Varus", "Varus")
Config.addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, true)
Config.addParam("W", "Use W", SCRIPT_PARAM_ONOFF, true)
Config.addParam("E", "Use E", SCRIPT_PARAM_ONOFF, true)
Config.addParam("R", "Use R", SCRIPT_PARAM_ONOFF, true)
Config.addParam("F", "LaneClear", SCRIPT_PARAM_ONOFF, true)
Config.addParam("Combo", "Combo", SCRIPT_PARAM_KEYDOWN, string.byte(" "))
--Start
OnLoop(function(myHero)
AutoIgnite()
LaneClearE()
if Config.Combo then
local unit = GetCurrentTarget()
if ValidTarget(unit, 1550) then
 
-- Varus E
    if Config.E then
        local EPred = GetPredictionForPlayer(GetMyHeroPos(),unit,GetMoveSpeed(unit),1700,250,850,50,false,true)
            if CanUseSpell(myHero, _E) == READY and EPred.HitChance == 1 then
            CastSkillShot(_E,EPred.PredPos.x,EPred.PredPos.y,EPred.PredPos.z)
            end
        end

-- Varus W
-- Varus Q
    if CanUseSpell(myHero, _Q) == READY and ValidTarget(target, 1625) and Config.Q then
      local myHeroPos = GetMyHeroPos()
      CastSkillShot(_Q, myHeroPos.x, myHeroPos.y, myHeroPos.z)
      for i=250, 1625, 250 do
        DelayAction(function()
            local _Qrange = 225 + math.min(225, i/2)
              local Pred = GetPredictionForPlayer(GetMyHeroPos(),unit,GetMoveSpeed(unit),1700,250,1625,50,false,true)
              if Pred.HitChance >= 1 then
                CastSkillShot2(_Q, Pred.PredPos.x, Pred.PredPos.y, Pred.PredPos.z)
              end
          end, i)
      end
    end
-- Varus R
             if Config.R then
    local RPred = GetPredictionForPlayer(GetMyHeroPos(),unit,GetMoveSpeed(unit),1600,250,1500,55,false,true)
    local ult = (GetCastLevel(myHero,_R)*200)+(GetBonusAP(myHero)*.6)
    if CanUseSpell(myHero, _R) == READY and IsInDistance(unit, 1550) then
    CastSkillShot(_R,RPred.PredPos.x,RPred.PredPos.y,RPred.PredPos.z)
                end
            end
    end

end
end)
function LaneClearE()
   if IWalkConfig.LaneClear then
    for _,Q in pairs(GetAllMinions(MINION_ENEMY)) do
          if IsInDistance(Q, 650) then
            if Config.F then
-- Syndra cast W at Enemy
        local EnemyPos = GetOrigin(Q)
            if CanUseSpell(myHero, _E) == READY then
            CastSkillShot(_E,EnemyPos.x,EnemyPos.y,EnemyPos.z)
    end
    end
end
end
end
end
PrintChat(string.format("<font color='#1244EA'>[CloudAIO]</font> <font color='#FFFFFF'>Varus Loaded</font>"))
end
