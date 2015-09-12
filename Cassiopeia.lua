require('Dlib')

local version = 6
local UP=Updater.new("D3ftsu/GoS/master/Common/Cassiopeia.lua", "Common\\Cassiopeia", version)
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

local root = menu.addItem(SubMenu.new("Cassiopeia"))

local Combo = root.addItem(SubMenu.new("Combo"))
local CUseQ = Combo.addItem(MenuBool.new("Use Q",true))
local CUseW = Combo.addItem(MenuBool.new("Use W",true))
local CUseE = Combo.addItem(MenuBool.new("Use E",true))
local CUseR = Combo.addItem(MenuBool.new("Use R",true))

local Harass = root.addItem(SubMenu.new("Harass"))
local HUseQ = Harass.addItem(MenuBool.new("Use Q",true))
local HUseW = Harass.addItem(MenuBool.new("Use W",true))
local HUseE = Harass.addItem(MenuBool.new("Use E",true))

local KillSteal = root.addItem(SubMenu.new("KillSteal"))
local KUseQ = KillSteal.addItem(MenuBool.new("Use Q",true))
local KUseW = KillSteal.addItem(MenuBool.new("Use W",true))
local KUseE = KillSteal.addItem(MenuBool.new("Use E",true))

local Misc = root.addItem(SubMenu.new("Misc"))
local MiscAutolvl = Misc.addItem(SubMenu.new("Auto level", true))
local MiscEnableAutolvl = MiscAutolvl.addItem(MenuBool.new("Enable", true))
local PacketCast = Misc.addItem(MenuBool.new("Packet Cast (Private :P)", true))
local nofaceexploit = Misc.addItem(MenuBool.new("No-Face Exploit (Private :P)", true))
local MiscInterrupt = Misc.addItem(MenuBool.new("Interrupt Dangerous Spells", true))
local MiscInterminHP = Misc.addItem(MenuSlider.new("Minimum Health % for Interrupt", 50, 1, 100, 1))

local Farm = root.addItem(SubMenu.new("Farm"))
local AutoE = Farm.addItem(MenuBool.new("Auto LastHit With E if Poisoned",true))
local LastHit2 = Farm.addItem(SubMenu.new("Lasthit with E"))
local EX = LastHit2.addItem(MenuBool.new("Enabled",true))
local EXP = LastHit2.addItem(MenuBool.new("Only if Poisoned",true))
local LaneClear = Farm.addItem(SubMenu.new("LaneClear"))
local LCUseE = LaneClear.addItem(MenuBool.new("Auto E",true))
local LCmin = LaneClear.addItem(MenuSlider.new("Minimum Mana % for Laneclear", 50, 1, 100, 1))

local JungleClear = root.addItem(SubMenu.new("JungleClear"))
local JUseQ = JungleClear.addItem(MenuBool.new("Use Q",true))
local JUseW = JungleClear.addItem(MenuBool.new("Use W",true))
local JUseE = JungleClear.addItem(MenuBool.new("Use E",true))

local Drawings = root.addItem(SubMenu.new("Drawings"))
local DrawingsQ = Drawings.addItem(MenuBool.new("Draw Q Range", true))
local DrawingsW = Drawings.addItem(MenuBool.new("Draw W Range", false))
local DrawingsE = Drawings.addItem(MenuBool.new("Draw E Range", false))
local DrawingsR = Drawings.addItem(MenuBool.new("Draw R Range", false))

CHANELLING_SPELLS = {
    ["Caitlyn"]                     = {_R},
    ["Katarina"]                    = {_R},
    ["FiddleSticks"]                = {_R},
    ["Galio"]                       = {_R},
    ["Lucian"]                      = {_R},
    ["MissFortune"]                 = {_R},
    ["VelKoz"]                      = {_R},
    ["Nunu"]                        = {_R},
    ["Karthus"]                     = {_R},
    ["Malzahar"]                    = {_R},
    ["Pantheon"]                    = {_R},
    ["Warwick"]                     = {_R},
    ["Xerath"]                      = {_R},
}

local callback = nil
 
OnProcessSpell(function(unit, spell)    
    if not callback or not unit or GetObjectType(unit) ~= Obj_AI_Hero  or GetTeam(unit) == GetTeam(GetMyHero()) then return end
    local unitChanellingSpells = CHANELLING_SPELLS[GetObjectName(unit)]
 
        if unitChanellingSpells then
            for _, spellSlot in pairs(unitChanellingSpells) do
                if spell.name == GetCastName(unit, spellSlot) then callback(unit, CHANELLING_SPELLS) end
            end
        end
end)
 
function addInterrupterCallback( callback0 )
        callback = callback0
end

-----------------------------------------------

OnLoop(function(myHero)
    if IWalkConfig.Combo then
	local target = GetCurrentTarget()

	    local unit = GetTarget(700, DAMAGE_MAGIC) 	 
     	local poisoned = false
		for i=0, 63 do
			if unit and GetBuffCount(unit,i) > 0 and GetBuffName(unit,i):lower():find("poison") then
				poisoned = true
			end
        end
		
		local QPred = GetPredictionForPlayer(GetMyHeroPos(),target,GetMoveSpeed(target),math.huge,600,850,75,false,true)
		local WPred = GetPredictionForPlayer(GetMyHeroPos(),target,GetMoveSpeed(target),2500,500,925,90,false,true)
		local RPred = GetPredictionForPlayer(GetMyHeroPos(),target,GetMoveSpeed(target),math.huge,300,800,180,false,true)
      
		if IsFacing(target, 800) and ValidTarget(target, 800) and CUseR.getValue() and (GetCurrentHP(target)/GetMaxHP(target))*100 <= 60 then
		CastSkillShot(_R,RPred.PredPos.x,RPred.PredPos.y,RPred.PredPos.z)
		end
		
	    if CanUseSpell(myHero, _E) == READY and CUseE.getValue() and ValidTarget(target, 700) and poisoned then
		CastTargetSpell(target, _E)
		end
			
		if CanUseSpell(myHero, _Q) == READY and CUseQ.getValue() and ValidTarget(target, 850) and QPred.HitChance == 1 then
		CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
		end
		
		if CanUseSpell(myHero, _W) == READY and CUseW.getValue() and ValidTarget(target, 925) and WPred.HitChance == 1 and not poisoned then
		CastSkillShot(_W,WPred.PredPos.x,WPred.PredPos.y,WPred.PredPos.z)
		end
	end
	
	if IWalkConfig.Harass then
	local target = GetCurrentTarget()

	    local unit = GetTarget(700, DAMAGE_MAGIC) 	 
     	local poisoned = false
		for i=0, 63 do
			if unit and GetBuffCount(unit,i) > 0 and GetBuffName(unit,i):lower():find("poison") then
				poisoned = true
			end
        end
		
		local QPred = GetPredictionForPlayer(GetMyHeroPos(),target,GetMoveSpeed(target),math.huge,600,850,75,false,true)
		local WPred = GetPredictionForPlayer(GetMyHeroPos(),target,GetMoveSpeed(target),2500,500,925,90,false,true)
		
	        if CanUseSpell(myHero, _E) == READY and HUseE.getValue() and ValidTarget(target, 700) and poisoned then
		CastTargetSpell(target, _E)
		end
			
		if CanUseSpell(myHero, _Q) == READY and HUseQ.getValue() and ValidTarget(target, 850) and QPred.HitChance == 1 then
		CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
		end
		
		if CanUseSpell(myHero, _W) == READY and HUseW.getValue() and ValidTarget(target, 925) and WPred.HitChance == 1 then
		CastSkillShot(_W,WPred.PredPos.x,WPred.PredPos.y,WPred.PredPos.z)
		end
	end
	
	for i,enemy in pairs(GetEnemyHeroes()) do
	
        local ExtraDmg = 0
		if GotBuff(myHero, "itemmagicshankcharge") > 99 then
		ExtraDmg = ExtraDmg + 0.1*GetBonusAP(myHero) + 100
		end
		
		local QPred = GetPredictionForPlayer(GetMyHeroPos(),enemy,GetMoveSpeed(enemy),math.huge,600,850,100,false,true)
		local WPred = GetPredictionForPlayer(GetMyHeroPos(),enemy,GetMoveSpeed(enemy),2500,500,850,90,false,true)
		local RPred = GetPredictionForPlayer(GetMyHeroPos(),enemy,GetMoveSpeed(enemy),math.huge,300,800,180,false,true)
		
		if CanUseSpell(myHero, _Q) == READY and QPred.HitChance == 1 and ValidTarget(enemy,GetCastRange(myHero,_Q)) and KUseQ.getValue() and GetCurrentHP(enemy) < CalcDamage(myHero, enemy, 0, 40*GetCastLevel(myHero,_Q)+35+.45*GetBonusAP(myHero) + ExtraDmg) then 
		CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
		elseif CanUseSpell(myHero, _W) == READY and WPred.HitChance == 1 and ValidTarget(enemy,GetCastRange(myHero,_W)) and KUseW.getValue() and GetCurrentHP(enemy) < CalcDamage(myHero, enemy, 0, 15*GetCastLevel(myHero,_W)+15+0.3*GetBonusAP(myHero) + ExtraDmg) then
		CastSkillShot(_W,WPred.PredPos.x,WPred.PredPos.y,WPred.PredPos.z)
		elseif CanUseSpell(myHero, _E) == READY and ValidTarget(enemy,GetCastRange(myHero,_E)) and KUseE.getValue() and GetCurrentHP(enemy) < CalcDamage(myHero, enemy, 0, 25*GetCastLevel(myHero,_E)+30+0.55*GetBonusAP(myHero) + ExtraDmg) then
		CastTargetSpell(enemy, _E)
		end
		
	end
	
if MiscEnableAutolvl.getValue() then  
    if GetLevel(myHero) >= 1 and GetLevel(myHero) < 2 then
	LevelSpell(_Q)
    elseif GetLevel(myHero) >= 2 and GetLevel(myHero) < 3 then
	LevelSpell(_E)
    elseif GetLevel(myHero) >= 3 and GetLevel(myHero) < 4 then
	LevelSpell(_W)
    elseif GetLevel(myHero) >= 4 and GetLevel(myHero) < 5 then
    LevelSpell(_E)
    elseif GetLevel(myHero) >= 5 and GetLevel(myHero) < 6 then
    LevelSpell(_E)
    elseif GetLevel(myHero) >= 6 and GetLevel(myHero) < 7 then
	LevelSpell(_R)
    elseif GetLevel(myHero) >= 7 and GetLevel(myHero) < 8 then
	LevelSpell(_E)
    elseif GetLevel(myHero) >= 8 and GetLevel(myHero) < 9 then
    LevelSpell(_Q)
    elseif GetLevel(myHero) >= 9 and GetLevel(myHero) < 10 then
    LevelSpell(_E)
    elseif GetLevel(myHero) >= 10 and GetLevel(myHero) < 11 then
    LevelSpell(_Q)
    elseif GetLevel(myHero) >= 11 and GetLevel(myHero) < 12 then
    LevelSpell(_R)
    elseif GetLevel(myHero) >= 12 and GetLevel(myHero) < 13 then
    LevelSpell(_Q)
    elseif GetLevel(myHero) >= 13 and GetLevel(myHero) < 14 then
    LevelSpell(_Q)
    elseif GetLevel(myHero) >= 14 and GetLevel(myHero) < 15 then
    LevelSpell(_W)
    elseif GetLevel(myHero) >= 15 and GetLevel(myHero) < 16 then
    LevelSpell(_W)
    elseif GetLevel(myHero) >= 16 and GetLevel(myHero) < 17 then
    LevelSpell(_R)
    elseif GetLevel(myHero) >= 17 and GetLevel(myHero) < 18 then
    LevelSpell(_W)
    elseif GetLevel(myHero) == 18 then
    LevelSpell(_W)
    end
end

for _,minion in pairs(GetAllMinions(MINION_ENEMY)) do

        local unit = minion
     	local poisoned = false
		for i=0, 63 do
			if unit and GetBuffCount(unit,i) > 0 and GetBuffName(unit,i):lower():find("poison") then
				poisoned = true
			end
        end
		
		local ExtraDmg = 0
		if GotBuff(myHero, "itemmagicshankcharge") > 99 then
		ExtraDmg = ExtraDmg + 0.1*GetBonusAP(myHero) + 100
		end

        if IWalkConfig.LaneClear then
		if CanUseSpell(myHero, _E) == READY and LCUseE.getValue() and IsInDistance(minion, 700) and poisoned and (GetCurrentMana(myHero)/GetMaxMana(myHero))*100 >= LCmin.getValue() then
		CastTargetSpell(minion, _E)
		end
	end
	
	if IWalkConfig.LastHit then 
		
	    if CanUseSpell(myHero, _E) == READY and EX.getValue() and EXP.getValue() and IsInDistance(minion, 700) and poisoned and GetCurrentHP(minion) < CalcDamage(myHero, minion, 0, 25*GetCastLevel(myHero,_E)+30+0.55*GetBonusAP(myHero) + ExtraDmg) then
		CastTargetSpell(minion, _E)
		elseif CanUseSpell(myHero, _E) == READY and EX.getValue() and not EXP.getValue() and IsInDistance(minion, 700) and GetCurrentHP(minion) < CalcDamage(myHero, minion, 0, 25*GetCastLevel(myHero,_E)+30+0.55*GetBonusAP(myHero) + ExtraDmg) then
		CastTargetSpell(minion, _E)
		end
	end
	
	if AutoE.getValue() then
	    if CanUseSpell(myHero, _E) == READY and IsInDistance(minion, 700) and poisoned and GetCurrentHP(minion) < CalcDamage(myHero, minion, 0, 25*GetCastLevel(myHero,_E)+30+0.55*GetBonusAP(myHero) + ExtraDmg) then
		CastTargetSpell(minion, _E)
		end
	end
end


for _,mob in pairs(GetAllMinions(MINION_JUNGLE)) do
        
		local mobPos = GetOrigin(mob)
        local unit = mob
     	local poisoned = false
		for i=0, 63 do
			if unit and GetBuffCount(unit,i) > 0 and GetBuffName(unit,i):lower():find("poison") then
				poisoned = true
			end
        end
		
   if IWalkConfig.LaneClear then
		
	    if CanUseSpell(myHero, _E) == READY and JUseE.getValue() and IsInDistance(mob, 700) and poisoned then
		CastTargetSpell(mob, _E)
		end
			
		if CanUseSpell(myHero, _Q) == READY and JUseQ.getValue() and IsInDistance(mob, 850) then
		CastSkillShot(_Q,mobPos.x, mobPos.y, mobPos.z)
		end
		
		if CanUseSpell(myHero, _W) == READY and JUseW.getValue() and IsInDistance(mob, 925) then
		CastSkillShot(_W,mobPos.x, mobPos.y, mobPos.z)
		end
	end
end
	
local HeroPos = GetOrigin(myHero)
if DrawingsQ.getValue() then DrawCircle(HeroPos.x,HeroPos.y,HeroPos.z,GetCastRange(myHero,_Q),3,100,0xff00ff00) end
if DrawingsW.getValue() then DrawCircle(HeroPos.x,HeroPos.y,HeroPos.z,GetCastRange(myHero,_W),3,100,0xff00ff00) end
if DrawingsE.getValue() then DrawCircle(HeroPos.x,HeroPos.y,HeroPos.z,GetCastRange(myHero,_E),3,100,0xff00ff00) end
if DrawingsR.getValue() then DrawCircle(HeroPos.x,HeroPos.y,HeroPos.z,GetCastRange(myHero,_R),3,100,0xff00ff00) end
end)

if (GetCurrentHP(myHero)/GetMaxHP(myHero))*100 <= MiscInterminHP.getValue() then
addInterrupterCallback(function(target, spellType)
  local RPred = GetPredictionForPlayer(GetMyHeroPos(),target,GetMoveSpeed(target),math.huge,600,800,180,false,true)
  if IsInDistance(target, GetCastRange(myHero,_R)) and IsFacing(target, 800) and MiscInterrupt.getValue() and CanUseSpell(myHero,_R) == READY and spellType == CHANELLING_SPELLS then
  CastSkillShot(_R,RPred.PredPos.x,RPred.PredPos.y,RPred.PredPos.z)
  end
end)
end

--------------------------------------Thanks Maxxxel For this <3--------------------------------
local myHero = GetMyHero()
local lastattackposition={true,true,true}

function IsFacing(targetFace,range,unit) 
	range=range or 99999
	unit=unit or myHero
	targetFace=targetFace
	if (targetFace and unit)~=nil and (ValidtargetUnit(targetFace,range,unit)) and GetDistance2(targetFace,unit)<=range then
		local unitXYZ= GetOrigin(unit)
		local targetFaceXYZ=GetOrigin(targetFace)
		local lastwalkway={true,true,true}
		local walkway = GetPredictionForPlayer(GetOrigin(unit),targetFace,GetMoveSpeed(targetFace),0,1000,2000,0,false,false)

		if walkway.PredPos.x==targetFaceXYZ.x then

			if lastwalkway.x~=nil then

				local d1 = GetDistance2(targetFace,unit)
    		local d2 = GetDistance2XYZ(lastwalkway.x,lastwalkway.z,unitXYZ.x,unitXYZ.z)
    		return d2 < d1


    	elseif lastwalkway.x==nil then
    		if lastattackposition.x~=nil and lastattackposition.name==GetObjectName(targetFace) then
					local d1 = GetDistance2(targetFace,unit)
    			local d2 = GetDistance2XYZ(lastattackposition.x,lastattackposition.z,unitXYZ.x,unitXYZ.z)
    			return d2 < d1
    		end
    	end
    elseif walkway.PredPos.x~=targetFaceXYZ.x then
    	lastwalkway={x=walkway.PredPos.x,y=walkway.PredPos.y,z=walkway.PredPos.z} 

    	if lastwalkway.x~=nil then
				local d1 = GetDistance2(targetFace,unit)
    		local d2 = GetDistance2XYZ(lastwalkway.x,lastwalkway.z,unitXYZ.x,unitXYZ.z)
    		return d2 < d1
    	end
    end
	end
end


function ValidtargetUnit(targetFace,range,unit)
    range = range or 25000
    unit = unit or myHero
    if targetFace == nil or GetOrigin(targetFace) == nil or IsImmune(targetFace,unit) or IsDead(targetFace) or not IsVisible(targetFace) or GetTeam(targetFace) == GetTeam(unit) or GetDistance2(targetFace,unit)>range then return false end
    return true
end

function GetDistance2(p1,p2)
    p1 = GetOrigin(p1) or p1
    p2 = GetOrigin(p2) or p2
    return math.sqrt(GetDistance2Sqr(p1,p2))
end

function GetDistance2Sqr(p1,p2)
    p2 = p2 or GetMyHeroPos()
    local dx = p1.x - p2.x
    local dz = (p1.z or p1.y) - (p2.z or p2.y)
    return dx*dx + dz*dz
end

function GetDistance2XYZ(x,z,x2,z2)
	if (x and z and x2 and z2)~=nil then
		a=x2-x
		b=z2-z
		if (a and b)~=nil then
			a2=a*a
			b2=b*b
			if (a2 and b2)~=nil then
				return math.sqrt(a2+b2)
			else
				return 99999
			end
		else
			return 99999
		end
	end	
end

OnProcessSpell(function(Object,spellProc)
	local Obj_Type = GetObjectType(Object)
	if Object~=nil and Obj_Type==Obj_AI_Hero then
		if spellProc.name~=nil then
			for i,enemy in pairs(GetEnemyHeroes()) do
				if ValidtargetUnit(enemy,25000) then
					local targetFaceXYZ=GetOrigin(enemy)
					if (spellProc.name:find("Attack") and spellProc.BaseName~=nil and spellProc.BaseName:find(GetObjectName(enemy))) then 

						if spellProc.startPos.x==targetFaceXYZ.x and spellProc.startPos.y==targetFaceXYZ.y and spellProc.startPos.z==targetFaceXYZ.z then 
							if spellProc.endPos.x ~=targetFaceXYZ.x and spellProc.endPos.y ~=targetFaceXYZ.y and spellProc.endPos.z ~=targetFaceXYZ.z then 

								lastattackposition={x=spellProc.endPos.x,y=spellProc.endPos.y,z=spellProc.endPos.z,Name=GetObjectName(enemy)}
								break
							else
								break
							end
						else
							break
						end
					else
						break
					end
				else
					break
				end
			end
		end
	end
end)
