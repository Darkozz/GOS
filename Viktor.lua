require('Dlib')

local version = 6
local UP=Updater.new("D3ftsu/GoS/master/Common/Viktor.lua", "Common\\Viktor", version)
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

PrintChat("D3ftland Viktor By Deftsu Loaded, Have A Good Game!")
Config = scriptConfig("Viktor", "Viktor")
Config.addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, true)
Config.addParam("W", "Use W", SCRIPT_PARAM_ONOFF, true)
Config.addParam("E", "Use E", SCRIPT_PARAM_ONOFF, true)
Config.addParam("R", "Use R", SCRIPT_PARAM_ONOFF, true)
Config.addParam("Autolvl", "Autolvl", SCRIPT_PARAM_ONOFF, false)
KSConfig = scriptConfig("KS", "Killsteal:")
KSConfig.addParam("KSQ", "Killsteal with Q", SCRIPT_PARAM_ONOFF, true)
KSConfig.addParam("KSE", "Killsteal with E", SCRIPT_PARAM_ONOFF, true)
KSConfig.addParam("KSR", "Killsteal with R", SCRIPT_PARAM_ONOFF, true)
HarassConfig = scriptConfig("Harass", "Harass:")
HarassConfig.addParam("HarassQ", "Harass Q (C)", SCRIPT_PARAM_ONOFF, true)
HarassConfig.addParam("HarassW", "Harass W (C)", SCRIPT_PARAM_ONOFF, true)
HarassConfig.addParam("HarassE", "Harass E (C)", SCRIPT_PARAM_ONOFF, true)
DrawingsConfig = scriptConfig("Drawings", "Drawings:")
DrawingsConfig.addParam("DrawQ","Draw Q", SCRIPT_PARAM_ONOFF, true)
DrawingsConfig.addParam("DrawW","Draw W", SCRIPT_PARAM_ONOFF, true)
DrawingsConfig.addParam("DrawE","Draw E", SCRIPT_PARAM_ONOFF, true)
DrawingsConfig.addParam("DrawR","Draw R", SCRIPT_PARAM_ONOFF, true)

myIAC = IAC()


OnLoop(function(myHero)
Drawings()

if Config.Autolvl then
LevelUp()
end

Killsteal()



        local target = GetTarget(1000, DAMAGE_MAGIC)
        local targetpos = GetOrigin(target)
		if ValidTarget(target, 1000) then
            
	           
				if IWalkConfig.Combo then	
					local EPred = GetPredictionForPlayer(GetMyHeroPos(),target,GetMoveSpeed(target),1200,0,1225,80,false,true)
					local myHeroPos = GetMyHeroPos()
                                        local StartPos = Vector(myHero) - 525 * (Vector(myHero) - Vector(target)):normalized()
					if CanUseSpell(myHero, _E) == READY and EPred.HitChance == 1 and Config.E then
					CastSkillShot3(_E,StartPos,EPred.PredPos)
					end
					
					if CanUseSpell(myHero, _Q) == READY and Config.Q then
					CastTargetSpell(target, _Q)
					end
					 
					local WPred = GetPredictionForPlayer(GetMyHeroPos(),target,GetMoveSpeed(target),math.huge,500,700,300,false,true)
					if CanUseSpell(myHero, _W) == READY and WPred.HitChance == 1 and Config.W then
					CastSkillShot(_W,WPred.PredPos.x,WPred.PredPos.y,WPred.PredPos.z)
					end
					 
			            if CanUseSpell(myHero, _R) == READY then
					local RPred = GetPredictionForPlayer(GetMyHeroPos(),target,GetMoveSpeed(target),math.huge,250,700,450,false,true)
				        local damage = CalcDamage(myHero, target, 0, 25 + 200*GetCastLevel(myHero,_R) + 1.25*GetBonusAP(myHero))
					if Config.R and RPred.HitChance == 1 and damage > GetCurrentHP(target) then
					CastSkillShot(_R,RPred.PredPos.x,RPred.PredPos.y,RPred.PredPos.z)
                                        elseif GetCastName(myHero, _R) == "viktorchaosstormguide" then
                                        CastSkillShot(_R, targetpos.x,targetpos.y, targetpos.z)
                                        end
				    end
				end
				
				 if IWalkConfig.Harass then	
					local EPred = GetPredictionForPlayer(GetMyHeroPos(),target,GetMoveSpeed(target),1200,0,1225,80,false,true)
					local myHeroPos = GetMyHeroPos()
                                        local StartPos = Vector(myHero) - 525 * (Vector(myHero) - Vector(target)):normalized()
					if CanUseSpell(myHero, _E) == READY and EPred.HitChance == 1 and HarassConfig.HarassE then
					CastSkillShot3(_E,StartPos,EPred.PredPos)
					end
					
					 if CanUseSpell(myHero, _Q) == READY and HarassConfig.HarassQ then
					 CastTargetSpell(target, _Q)
					 end
					 
					 local WPred = GetPredictionForPlayer(GetMyHeroPos(),target,GetMoveSpeed(target),math.huge,500,700,300,false,true)
					 if CanUseSpell(myHero, _W) == READY and WPred.HitChance == 1 and HarassConfig.HarassW then
					 CastSkillShot(_W,WPred.PredPos.x,WPred.PredPos.y,WPred.PredPos.z)
					 end
					 
					 if GetCastName(myHero, _R) == "viktorchaosstormguide" then
                                         CastSkillShot(_R, targetpos.x,targetpos.y, targetpos.z)
                                         end
					 
                               end
				
		end
end)

function Killsteal()
	for i,enemy in pairs(GetEnemyHeroes()) do
		local EPred = GetPredictionForPlayer(GetMyHeroPos(),enemy,GetMoveSpeed(enemy),1200,0,1225,80,false,true)
        local RPred = GetPredictionForPlayer(GetMyHeroPos(),enemy,GetMoveSpeed(enemy),math.huge,250,700,450,false,true)
        local StartPos = Vector(myHero) - 525 * (Vector(myHero) - Vector(enemy)):normalized()
		if CanUseSpell(myHero, _E) == READY and EPred.HitChance == 1 and ValidTarget(enemy,1225) and KSConfig.KSE and GetCurrentHP(enemy) < CalcDamage(myHero, enemy, 0, 45*GetCastLevel(myHero,_E) + 25 + 0.7*GetBonusAP(myHero)) then
		CastSkillShot3(_E,StartPos,EPred.PredPos)

		elseif CanUseSpell(myHero, _R) == READY and RPred.HitChance == 1 and ValidTarget(enemy, GetCastRange(myHero, _R)) and KSConfig.KSR and GetCurrentHP(enemy) < CalcDamage(myHero, enemy, 0, 100*GetCastLevel(myHero,_R) + 50 + 0.55*GetBonusAP(myHero)) then  
        CastSkillShot(_R,RPred.PredPos.x,RPred.PredPos.y,RPred.PredPos.z)
		
        elseif CanUseSpell(myHero,_Q) == READY and ValidTarget(enemy, GetCastRange(myHero,_Q)) and KSConfig.KSQ and GetCurrentHP(enemy) < CalcDamage(myHero, enemy, 0, 20*GetCastLevel(myHero,_Q) + 20 + 0.2*GetBonusAP(myHero)) then
        CastTargetSpell(enemy, _Q)
              
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

function Drawings()
myHeroPos = GetOrigin(myHero)
if CanUseSpell(myHero, _Q) == READY and DrawingsConfig.DrawQ then DrawCircle(myHeroPos.x,myHeroPos.y,myHeroPos.z,GetCastRange(myHero,_Q),3,100,0xff00ff00) end
if CanUseSpell(myHero, _W) == READY and DrawingsConfig.DrawW then DrawCircle(myHeroPos.x,myHeroPos.y,myHeroPos.z,GetCastRange(myHero,_W),3,100,0xff00ff00) end
if CanUseSpell(myHero, _E) == READY and DrawingsConfig.DrawE then DrawCircle(myHeroPos.x,myHeroPos.y,myHeroPos.z,1225,3,100,0xff00ff00) end
if CanUseSpell(myHero, _R) == READY and DrawingsConfig.DrawR then DrawCircle(myHeroPos.x,myHeroPos.y,myHeroPos.z,GetCastRange(myHero,_R),3,100,0xff00ff00) end
end
AddGapcloseEvent(_W, 0, false)
