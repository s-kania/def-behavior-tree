local BehaviourTree = require "def_behavior_tree.behavior_tree"

local M = {}

local TASKS = {
	IS_ALIVE = "IS_ALIVE",
}

local TREES = {
	SHIP_BT = "SHIP_BT",
}

M.NODES = {
	--[[
	**** TASKS **** 
	]]--
	[TASKS.IS_ALIVE] = {
		type = BehaviourTree.Task,
		run = function(task, payload)
            print('sukces jestem zywy')
            return task:fail()
			-- if entity:isAlive() then
			-- 	task:success()
			-- else
			-- 	task:fail()
			-- end
		end
	},

	--[[
	**** SEQUENCES **** 
	]]--

	--[[
	**** TREES **** 
	]]--

	[TREES.SHIP_BT] = {
		type = BehaviourTree.RepeatUntilFail,
		nodes = {
			TASKS.IS_ALIVE,
		},
	},
}

return M