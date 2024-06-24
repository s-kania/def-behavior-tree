-- local Composite  = require "def_behavior_tree.node_types.composite"
-- local Sequence = class("Sequence", Composite)

-- function Sequence:success()
--   Composite.success(self)
--   self.actualTaskIndex = self.actualTaskIndex + 1
--   if self.actualTaskIndex <= #self.nodes_id_list then
--     self:_run()
--   else
--     self:getParent():success()
--   end
-- end

-- function Sequence:fail()
--   Composite.fail(self)
--   self:getParent():fail()
-- end

-- return Sequence
local Composite = require "def_behavior_tree.node_types.composite"
local Sequence = {}

Sequence.name = "Sequence"

function Sequence:getNextNode(tree_state)
    local currentNodeIndex = table.indexOf(self.nodes_id_list, tree_state.runningNodeID)
    local nextNodeID = self.nodes_id_list[currentNodeIndex + 1]

    return nextNodeID and tree_state:getNode(nextNodeID)
end

function Sequence:start(tree_state)
  local node = tree_state:getCurrentNode()
  tree_state:setRunningNodeID(node.nodes_id_list[1])
end

function Sequence:run(tree_state)
  Composite:run(tree_state)
end

-- function Sequence:finish(tree_state)

-- end

function Sequence:success(tree_state)
  Composite:success(tree_state)
  -- self.actualTaskIndex = self.actualTaskIndex + 1
  local nextNode = self:getNextNode(tree_state)

  if nextNode then
    Composite:run()
  else
    tree_state:getCurrentNodeParent():success(tree_state)
  end
end

function Sequence:fail(tree_state)
  Composite:fail(tree_state)
  tree_state:getCurrentNodeParent():fail(tree_state)
end

return Sequence

