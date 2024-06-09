local BehaviourTree = require "def_behavior_tree.behavior_tree"

local M = {}

local TASKS = {
	IS_ALIVE = "IS_ALIVE",
	WAIT = "WAIT",
	SELECT_CLOSEST_METEOR = "SELECT_CLOSEST_METEOR",
	SHOOT_TARGET_METEOR = "SHOOT_TARGET_METEOR",
	DANCE = "DANCE",
	STOP_DANCE = "STOP_DANCE",
}

local SEQUENCES = {
	DANCE_UNTIL_FIND_ENEMY = "DANCE_UNTIL_FIND_ENEMY",
	SHIP_AI = "SHIP_AI",
}

M.TREES = {
	SHIP_BT = {
		main_node = SEQUENCES.SHIP_AI
	},
}

M.NODES = {
	--[[
	**** TASKS **** 
	]]--
	[TASKS.IS_ALIVE] = {
		type = BehaviourTree.Task,
		run = function(task, payload)
			if lives > 0 then
				task:success()
			else
				task:fail()
			end
		end
	},

	[TASKS.WAIT] = {
		type = BehaviourTree.Task,
		run = function(task, payload)
			timer.delay(0.1, false, function ()
				task:success()
			end)
		end
	},
	
	[TASKS.SELECT_CLOSEST_METEOR] = {
		type = BehaviourTree.Task,
		run = function(task, payload)
			local ship_position = vmath.vector3(320, 568, 0)

			local closest_meteor_id = nil

			for meteor_id, exist in pairs(meteors) do
				if exist then
					local meteor_distance_from_ship = vmath.length(ship_position - go.get_position(meteor_id))
					local closest_meteor_distance_from_ship = vmath.length(ship_position - go.get_position(closest_meteor_id))
					if meteor_distance_from_ship < 400 and (closest_meteor_id == nil or meteor_distance_from_ship < closest_meteor_distance_from_ship) then
						closest_meteor_id = meteor_id
					end
				end
			end

			if closest_meteor_id and go.exists(closest_meteor_id) then
				payload.target_meteor = closest_meteor_id
				task:success()
			else
				task:fail()
			end

		end
	},

	[TASKS.SHOOT_TARGET_METEOR] = {
		type = BehaviourTree.Task,
		run = function(task, payload)
			if payload.target_meteor == nil or not go.exists(payload.target_meteor) then
				return task:fail()
			end

			local ship_position = vmath.vector3(320, 568, 0)
			local meteor_position = go.get_position(payload.target_meteor)

			local pos = ship_position - meteor_position
			local rot_between_ship_and_meteor = vmath.quat_rotation_z(math.atan2(pos.y, pos.x) + math.pi / 2)
			payload.direction = rot_between_ship_and_meteor

			local function shoot(self, handle, time_elapsed)
				task.counter = task.counter + 1
				local offset = vmath.rotate(payload.direction, vmath.vector3(0, 50, 0))
				factory.create("#laserfactory", go.get_position() + offset)
				if task.counter == 3 then
					payload.target_meteor = nil
				  	timer.cancel(handle) -- cancel timer after 10 calls
					task:success()
				end
			  end
			  
			task.counter = 0
			timer.delay(0.12, true, shoot)
		end
	},

	[TASKS.DANCE] = {
		type = BehaviourTree.Task,
		run = function(task, payload)
			payload.thrust = true
			payload.rot = payload.rot_left
			-- if action.pressed then
			-- payload.speed = 0
			-- end
			task:success()
		end
	},

	[TASKS.STOP_DANCE] = {
		type = BehaviourTree.Task,
		run = function(task, payload)
			payload.speed = 0
			task:success()
		end
	},

	--[[
	**** SEQUENCES **** 
	]]--

	[SEQUENCES.DANCE_UNTIL_FIND_ENEMY] = {
		type = BehaviourTree.Sequence,
		nodes = {
			{
				type = BehaviourTree.RepeatUntilFail,
				nodes = {
					{
						decorator = BehaviourTree.InvertDecorator,
						node = TASKS.SELECT_CLOSEST_METEOR,
					},
					TASKS.DANCE,
					TASKS.WAIT,
				},
			},
			TASKS.STOP_DANCE,
		}
	},

	[SEQUENCES.SHIP_AI] = {
		type = BehaviourTree.RepeatUntilFail,
		nodes = {
			TASKS.IS_ALIVE,
			SEQUENCES.DANCE_UNTIL_FIND_ENEMY,
			TASKS.SHOOT_TARGET_METEOR,
			TASKS.WAIT,
		},
	},
}

return M