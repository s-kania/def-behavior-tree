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

-- function Composite:getNextNode(tree_state)
--     local nodeID = tree_state.runningNodeID

--     if nodeID == self.id then
--       return self.nodes_id_list[1]
--     end

--     local currentNodeID = table.indexOf(self.nodes_id_list, nodeID)
--     local nextNodeID = self.nodes_id_list[currentNodeID + 1]

--     return nextNodeID and tree_state:getNode(nextNodeID)
-- end

function Sequence.getNextNode(tree_state)
    local sequenceNode = tree_state:getCurrentNodeParent()
    local currentNodeIndex = table.indexOf(sequenceNode.nodes_id_list, tree_state.runningNodeID)
    local nextNodeID = sequenceNode.nodes_id_list[currentNodeIndex + 1]

    return nextNodeID and tree_state:getNode(nextNodeID)
end

function Sequence.start(tree_state)
    local node = tree_state:getCurrentNode()
    tree_state:setRunningNodeID(node.nodes_id_list[1])
end

function Sequence.run(tree_state)
     Composite.run(tree_state)
end

-- function Sequence.finish(tree_state)

-- end

function Sequence.success(tree_state)
    Composite.success(tree_state)
    -- Sequence.actualTaskIndex = Sequence.actualTaskIndex + 1
    local nextNode = Sequence.getNextNode(tree_state)

    if nextNode then
        tree_state:setRunningNodeID(nextNode.id)
        Composite.run(tree_state)
    else
        local sequenceNode = tree_state:getCurrentNodeParent()
        tree_state:setRunningNodeID(sequenceNode.id)
        tree_state:getCurrentNodeParent().success(tree_state)
    end
end

function Sequence.fail(tree_state)
    Composite.fail(tree_state)
    local sequenceNode = tree_state:getCurrentNodeParent()
    tree_state:setRunningNodeID(sequenceNode.id)
    tree_state:getCurrentNodeParent().fail(tree_state)
end

return Sequence

