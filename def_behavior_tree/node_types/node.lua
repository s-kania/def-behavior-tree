-- local Node      = class("Node")

-- function Node:initialize(config)
--   config = config or {}
--   for k, v in pairs(config) do
--     self[k] = v
--   end
-- end

-- function Node:_startTask(payload) end
-- function Node:_runTask(payload) end
-- function Node:_finishTask(payload) end

-- function Node:start()
--   self._startTask(self, self.treeState.payload)
-- end

-- function Node:run()
--   self._runTask(self, self.treeState.payload)
-- end

-- function Node:finish()
--   self._finishTask(self, self.treeState.payload)
-- end

-- function Node:success()
--   self:getParent():success()
-- end

-- function Node:fail()
--   self:getParent():fail()
-- end

-- function Node:getParent()
--   return self.treeState:getNode(self.parent_id)
-- end

-- return Node

local Node = {}

Node.name = "Node"

-- function Node:initialize(config)
--   config = config or {}
--   for k, v in pairs(config) do
--     self[k] = v
--   end
-- end

function Node.start(tree_state) end
function Node.run(tree_state) end
function Node.finish(tree_state) end

-- function Node:start()
--   self._startTask(self, self.treeState.payload)
-- end

-- function Node:run()
--   self._runTask(self, self.treeState.payload)
-- end

-- function Node:finish()
--   self._finishTask(self, self.treeState.payload)
-- end

function Node.success(tree_state)
    tree_state:getCurrentNodeParent().success(tree_state)
end

function Node.fail(tree_state)
    tree_state:getCurrentNodeParent().fail(tree_state)
end

return Node