local GameControl = {}
GameControl.__index = table

GameControl.nameHero = "npc_dota_hero_sniper"

GameControl.number_creep = 1

function GameControl:InitialValue()

	--------- get tower
	GameControl.midRadianTower = Entities:FindByName (nil, "dota_goodguys_tower1_mid")
	GameControl.mid2RadianTower = Entities:FindByName (nil, "dota_goodguys_tower2_mid")
	GameControl.mid3RadianTower = Entities:FindByName (nil, "dota_goodguys_tower3_mid")
	GameControl.midDireTower = Entities:FindByName (nil, "dota_badguys_tower1_mid")

	--------- Hero Find
	GameControl.hero = Entities:FindByName(nil, GameControl.nameHero)		
	GameControl.hero:SetBaseDamageMin(18)
	GameControl.hero:SetBaseDamageMax(18)
	print(GameControl.hero:GetAttackDamage())

	--------- Hero Properties	
	GameControl.attackRangeHero = GameControl.hero:GetAttackRange()	
	

	GameControl.distanceBetweenRadianTower = CalcDistanceBetweenEntityOBB( GameControl.midRadianTower, GameControl.mid3RadianTower)
	GameControl.maxDistance = CalcDistanceBetweenEntityOBB( GameControl.midRadianTower, GameControl.midDireTower)
  
  print("test")

	----------- respawn	
	GameControl:CreateCreep()
	GameControl:resetThing()
end

function GameControl:resetThing() 
	FindClearSpaceForUnit(GameControl.hero, GameControl.midRadianTower:GetAbsOrigin() + Vector(500,500,0) , true)
	--RandomVector( RandomFloat( 0, 200 ))
	

	GameControl.hero:SetHealth( GameControl.hero:GetMaxHealth() )
	GameControl.midRadianTower:SetHealth( GameControl.midRadianTower:GetMaxHealth() )
	GameControl.midDireTower:SetHealth( GameControl.midDireTower:GetMaxHealth() )
end

function GameControl:resetAll()
	GameControl:ForceKillCreep()
end

--[[
        Creep Function
--]] 

function GameControl:CreateCreep()
    --------------- Create Radian Creep
	local goodSpawn_Radian = GameControl.midRadianTower
	local goodWP_Radian = Entities:FindByName ( nil, "lane_mid_pathcorner_goodguys_1")
	GameControl.creeps_Radian = {}
	for i = 1, 4 do
		GameControl.creeps_Radian[i] = CreateUnitByName( "npc_dota_creep_goodguys_melee", goodSpawn_Radian:GetAbsOrigin() + Vector(1000,1000,0), true, nil, nil, DOTA_TEAM_GOODGUYS )
	end
	-- GameControl.creeps_Radian[4] = CreateUnitByName( "npc_dota_creep_goodguys_ranged" , goodSpawn_Radian:GetAbsOrigin() + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
	for i = 1, 4 do
		GameControl.creeps_Radian[i]:SetInitialGoalEntity( goodWP_Radian )
		GameControl.creeps_Radian[i]:SetBaseDamageMin(21)
		GameControl.creeps_Radian[i]:SetBaseDamageMax(21)
		print(GameControl.creeps_Radian[i]:GetAttackDamage()	)
		-- print(creeps_Radian[i]:GetName())
	end


	--------------- Create Dire Creep
	local goodSpawn_Dire = GameControl.midDireTower
	local goodWP_Dire = Entities:FindByName ( nil, "lane_mid_pathcorner_badguys_1")
	GameControl.creeps_Dire = {}
	for i = 1, GameControl.number_creep do
		GameControl.creeps_Dire[i] = CreateUnitByName( "npc_dota_creep_goodguys_melee", goodSpawn_Dire:GetAbsOrigin() + Vector(-1000,-1000,0), true, nil, nil, DOTA_TEAM_BADGUYS )

	end
	-- GameControl.creeps_Dire[4] = CreateUnitByName( "npc_dota_creep_goodguys_ranged" , goodSpawn_Dire:GetAbsOrigin() + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS )
	local randomNum = RandomInt(1, 10)
	for i = 1, GameControl.number_creep do
		GameControl.creeps_Dire[i]:SetInitialGoalEntity( goodWP_Dire )
		GameControl.creeps_Dire[i]:SetBaseDamageMin(21)
		GameControl.creeps_Dire[i]:SetBaseDamageMax(21)
		-- creeps_Dire[i]:SetForceAttackTarget(hero)
	end
end

function GameControl:ForceKillCreep(creeps)
	local allCreeps =  Entities:FindAllByName("npc_dota_creep_lane")
	for idx,creep in pairs( allCreeps ) do
		-- print(creep:GetName())
		if(creep ~= nil and creep:IsNull() == false and creep:IsAlive() )then
			creep:ForceKill(false)
		end
	end
end


function GameControl:runAction(action,state)
	if CalcDistanceBetweenEntityOBB( GameControl.hero, GameControl.creeps_Dire[1]) < 500 then
		if action == 0 then
			GameControl.hero:Stop()
			-- print('stop')
			return 0.1
		elseif action == 1 then
			GameControl.hero:Stop()
			if state[2] == 0 then
				GameControl.hero:MoveToTargetToAttack(GameControl.creeps_Dire[1])
				return 0.4
			else
				return 0.1
			end
			-- print('hit')
			
			
		end
	else
		GameControl.hero:MoveToTargetToAttack(GameControl.midDireTower)
		return 0.1
	end
end
--[[
        Server Function
--]] 
-- function GameControl:requestActionFromServer(method, input)
--     input = input or {}
--     local dataSend = {}
--     dataSend['method'] = method

--     if dataSend['method'] == GET_DQN_DETAIL then
-- 		print("GET DQN")

-- 	elseif dataSend['method'] == UPPDATE_MODEL_STATE then
-- 		print("update model")
-- 		dataSend['mem_episode'] = dqn_agent.memory

--     end
    
--     request = CreateHTTPRequestScriptVM("POST", "http://localhost:8080" )
-- 	request:SetHTTPRequestHeaderValue("Accept", "application/json")
--     request:SetHTTPRequestRawPostBody('application/json', dkjson.encode(dataSend))

--     request:Send( function( result )

-- 		if result["StatusCode"] == 200 then
--             dict_value = dkjson.decode(result['Body'])

--             if dataSend['method'] == GET_DQN_DETAIL then
                
--             elseif dataSend['method'] == UPPDATE_MODEL_STATE then
--                 dqn_agent.memory = {}             
--             end

--         end

-- 	end )

-- end


--[[
        Agent Function
--]] 
function GameControl:getState()
	local stateArray = {}
	local stateTemp = {}
	-- print("getState")	
	time_now = GameRules:GetGameTime()
	-- stateArray[1] = normalize(GameControl.creeps_Dire[1]:GetHealth(), 0, GameControl.creeps_Dire[1]:GetMaxHealth() )
	-- stateArray[2] = normalize(GameControl.hero:TimeUntilNextAttack(), 0 ,GameControl.hero:GetBaseAttackTime() )
	stateArray[1] = GameControl.creeps_Dire[1]:GetHealth() /550
	stateArray[2] = GameControl.hero:TimeUntilNextAttack() 
	stateTemp[1] = (GameControl.creeps_Radian[1]:GetLastAttackTime() + 1) - time_now
	stateTemp[2] = (GameControl.creeps_Radian[2]:GetLastAttackTime() + 1) - time_now
	stateTemp[3] = (GameControl.creeps_Radian[3]:GetLastAttackTime() + 1) - time_now
	stateTemp[4] = (GameControl.creeps_Radian[4]:GetLastAttackTime() + 1) - time_now 
	-- print("tttt "..time_now)
	-- for key,value in pairs(stateTemp) do 
	-- 	print(key.." "..value )
	-- end
	table.sort(stateTemp)
	stateArray[3] = stateTemp[1]
	stateArray[4] = stateTemp[2]
	stateArray[5] = stateTemp[3]
	stateArray[6] = stateTemp[4]
	-- for key,value in pairs(stateArray) do 
	-- 	print(key.." "..value )
	-- end
 

	return stateArray
end

--[[
        Other Function
--]] 

function GameControl:shallowcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function normalize(value, min, max)
	return (value - min) / (max - min)
end

return GameControl

