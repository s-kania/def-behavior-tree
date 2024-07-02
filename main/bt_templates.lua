local BehaviourTree = require "def_behavior_tree.behavior_tree"

local M = {}

local TASKS = {
	IS_ALIVE = "IS_ALIVE",
	WAIT = "WAIT",
	SELECT_CLOSEST_METEOR = "SELECT_CLOSEST_METEOR",
	SHOOT_TARGET_METEOR = "SHOOT_TARGET_METEOR",
	DANCE = "DANCE",
	STOP_DANCE = "STOP_DANCE",
    SET_ONE_SHOOT = "SET_ONE_SHOOT",
    SET_THREE_SHOOTS = "SET_THREE_SHOOTS",
}

local COMPOSITES = {
	DANCE_UNTIL_FIND_ENEMY = "DANCE_UNTIL_FIND_ENEMY",
	SHIP_AI = "SHIP_AI",
    GET_RANDOM_SHOOTS_NUMBER = "GET_RANDOM_SHOOTS_NUMBER",
}

M.TREES = {
	SHIP_BT = {
		main_node = COMPOSITES.SHIP_AI
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
            local scan_distance = 400

			for meteor_id, exist in pairs(meteors) do
				if exist then
					local meteor_distance_from_ship = vmath.length(ship_position - go.get_position(meteor_id))
					local closest_meteor_distance_from_ship = vmath.length(ship_position - go.get_position(closest_meteor_id))
					if meteor_distance_from_ship < scan_distance and (closest_meteor_id == nil or meteor_distance_from_ship < closest_meteor_distance_from_ship) then
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

            local timer_task = {}
			local function shoot(self, handle, time_elapsed)
				timer_task.counter = timer_task.counter + 1
				local offset = vmath.rotate(payload.direction, vmath.vector3(0, 50, 0))
				factory.create("player#laserfactory", go.get_position(payload.id) + offset, go.get_rotation(payload.id))
				if timer_task.counter == payload.shoots then
					payload.target_meteor = nil
				  	timer.cancel(handle)
					task:success()
				end
			  end
			  
			timer_task.counter = 0
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

    [TASKS.SET_ONE_SHOOT] = {
        type = BehaviourTree.Task,
        run = function (task, payload)
            payload.shoots = 1
            task:success()
        end
    },

    [TASKS.SET_THREE_SHOOTS] = {
        type = BehaviourTree.Task,
        run = function (task, payload)
            payload.shoots = 3
            task:success()
        end
    },

	--[[
	**** COMPOSITES **** 
	]]--

	[COMPOSITES.DANCE_UNTIL_FIND_ENEMY] = {
		type = BehaviourTree.Sequence,
		nodes = {
			{
				type = BehaviourTree.RepeatUntilFailDecorator,
				node = {
					type = BehaviourTree.Sequence,
					nodes = {
						{
							type = BehaviourTree.InvertDecorator,
							node = TASKS.SELECT_CLOSEST_METEOR,
						},
						TASKS.DANCE,
						TASKS.WAIT,
					},
				},
			},
			TASKS.STOP_DANCE,
		}
	},

    [COMPOSITES.GET_RANDOM_SHOOTS_NUMBER] = {
        type = BehaviourTree.RandomWithChances,
        nodes = {
            {
                type = BehaviourTree.ChanceDecorator,
                chance = 30,
                node = TASKS.SET_THREE_SHOOTS,
            },
            {
                type = BehaviourTree.ChanceDecorator,
                chance = 70,
                node = TASKS.SET_ONE_SHOOT,
            },
        }
    },

	[COMPOSITES.SHIP_AI] = {
		type = BehaviourTree.RepeatUntilFailDecorator,
		node = {
			type = BehaviourTree.Sequence,
			nodes = {
				TASKS.IS_ALIVE,
				COMPOSITES.DANCE_UNTIL_FIND_ENEMY,
                COMPOSITES.GET_RANDOM_SHOOTS_NUMBER,
				TASKS.SHOOT_TARGET_METEOR,
				TASKS.WAIT,
			},
		},
	},
}

return M