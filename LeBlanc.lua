require('Dlib')

local version = 6
local UP=Updater.new("D3ftsu/GoS/master/Common/LeBlanc.lua", "Common\\LeBlanc", version)
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
require('Inspired')

Menu = scriptConfig("lb", "Sterling LeBlanc")
	Menu.addParam("Q", "Use Q in Combo", SCRIPT_PARAM_ONOFF, true)
	Menu.addParam("W", "Use W in Combo", SCRIPT_PARAM_ONOFF, true)
	Menu.addParam("E", "Use E in Combo", SCRIPT_PARAM_ONOFF, true)
	Menu.addParam("R", "Use R in Combo", SCRIPT_PARAM_ONOFF, true)
	Menu.addParam("Autolvl", "Autolvl", SCRIPT_PARAM_ONOFF, false)
	Menu.addParam("combo", "Combo Key", SCRIPT_PARAM_KEYDOWN, string.byte(" "))
	DrawingsConfig = scriptConfig("Drawings", "Drawings:")
    DrawingsConfig.addParam("DrawQ","Draw Q", SCRIPT_PARAM_ONOFF, true)
    DrawingsConfig.addParam("DrawW","Draw W", SCRIPT_PARAM_ONOFF, true)
    DrawingsConfig.addParam("DrawE","Draw E", SCRIPT_PARAM_ONOFF, true)
    DrawingsConfig.addParam("DrawR","Draw R", SCRIPT_PARAM_ONOFF, true)
	
local myHero = GetMyHero()

OnLoop(function(myHero)
Drawings()
	myHeroPos = GetOrigin(myHero)
	local target = GetCurrentTarget()
	if Menu.combo then
	
	    	if CanUseSpell(myHero, _Q) == READY and Menu.Q then
			if ValidTarget(target, 700) then
				CastTargetSpell(target, _Q)
			end
		end
		
		 if CanUseSpell(myHero, _R) == READY and Menu.R then
			if ValidTarget(target, 700) then
				CastTargetSpell(target, _R)
			end
		end
		
		if CanUseSpell(myHero, _W) == READY and Menu.W and GetCastName(myHero, _W) ~= "leblancslidereturn" then
			if ValidTarget(target, 600) then
				local WPred = GetPredictionForPlayer(myHeroPos, target, GetMoveSpeed(target), 1500, 0, 600, 220, false, false)
				if WPred.HitChance == 1 then
					CastSkillShot(_W, WPred.PredPos.x, WPred.PredPos.y, WPred.PredPos.z)
				end
			end
		end
		
		if CanUseSpell(myHero, _E) == READY and Menu.E then
			if ValidTarget(target, 900) then 
				local EPred = GetPredictionForPlayer(myHeroPos, target, GetMoveSpeed(target), 1600, 250, 900, 70, true, true)				
				if EPred.HitChance == 1 then
					CastSkillShot(_E, EPred.PredPos.x, EPred.PredPos.y, EPred.PredPos.z)
				end
			end
		end
	end	
end)

function Drawings()
myHeroPos = GetOrigin(myHero)
if CanUseSpell(myHero, _Q) == READY and DrawingsConfig.DrawQ then DrawCircle(myHeroPos.x,myHeroPos.y,myHeroPos.z,GetCastRange(myHero,_Q),3,100,0xff00ff00) end
if CanUseSpell(myHero, _W) == READY and DrawingsConfig.DrawW then DrawCircle(myHeroPos.x,myHeroPos.y,myHeroPos.z,GetCastRange(myHero,_W),3,100,0xff00fc000) end
if CanUseSpell(myHero, _E) == READY and DrawingsConfig.DrawE then DrawCircle(myHeroPos.x,myHeroPos.y,myHeroPos.z,GetCastRange(myHero,_E),3,100,0xff00ffc0) end
if CanUseSpell(myHero, _R) == READY and DrawingsConfig.DrawR then DrawCircle(myHeroPos.x,myHeroPos.y,myHeroPos.z,GetCastRange(myHero,_R),3,100,0xff00ffd0) end
end
if GetLevel(myHero) == 1 then
	LevelSpell(_W)
elseif GetLevel(myHero) == 2 then
	LevelSpell(_Q)
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
        LevelSpell(_W)
elseif GetLevel(myHero) == 9 then
        LevelSpell(_Q)
elseif GetLevel(myHero) == 10 then
        LevelSpell(_W)
elseif GetLevel(myHero) == 11 then
        LevelSpell(_R)
elseif GetLevel(myHero) == 12 then
        LevelSpell(_W)
elseif GetLevel(myHero) == 13 then
        LevelSpell(_W)
elseif GetLevel(myHero) == 14 then
        LevelSpell(_E)
elseif GetLevel(myHero) == 15 then
        LevelSpell(_E)
elseif GetLevel(myHero) == 16 then
        LevelSpell(_R)
elseif GetLevel(myHero) == 17 then
        LevelSpell(_E)
elseif GetLevel(myHero) == 18 then
        LevelSpell(_E)
end
end
