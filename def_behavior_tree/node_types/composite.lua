-- local Registry = require "def_behavior_tree.registry"
-- local Node  = require "def_behavior_tree.node_types.node"
-- local Composite = class("Composite", Node)

-- function Composite:start()
--   self.actualTaskIndex = 1
-- end

-- -- w priority/sequence/repeat_until_fail uzywane jest _run aby pominac sprawdzanie actuaTaskIndex ktore jest wyzej
-- -- a jest wyzej bo jest tez warunek else
-- -- jednakze run tutaj moglby zwracac fail
-- -- wtedy nie byloby potrzeby posiadania dwóch funkcji
-- function Composite:run()
--   if self.actualTaskIndex <= #self.nodes_id_list then
--     self:_run()
--   end
-- end

-- function Composite:_run()
--   -- TODO w teori mozemy wyjebac actualTaskIndex i zamiast tego zrobic wyszukiwanie kolejnego node w liscie nodes_id_list,
--   -- ewentualnie do zadania implementujemy informacje o nextNode, ale to chyba pierwsza opcja lepsza
--   local nodeID = self.nodes_id_list[self.actualTaskIndex]

--   self.node = self.treeState:getNode(nodeID)

--   -- self.treeState:setRunningNodeID(nodeID)
--   self.node:start()
--   self.node:run()
-- end


-- function Composite:success()
--   self.node:finish()
--   self.node = nil
-- end

-- function Composite:fail()
--   self.node:finish()
--   self.node = nil
-- end

-- return Composite

local Composite = {}

Composite.name = "Composite"

-- function Composite:getNextNode(tree_state)
--     local nodeID = tree_state.runningNodeID

--     if nodeID == self.id then
--       return self.nodes_id_list[1]
--     end

--     local currentNodeID = table.indexOf(self.nodes_id_list, nodeID)
--     local nextNodeID = self.nodes_id_list[currentNodeID + 1]

--     return nextNodeID and tree_state:getNode(nextNodeID)
-- end

-- function Composite:getCurrentNode(tree_state)
--   local nodeID = tree_state.runningNodeID

--   if nodeID == self.id then
--     local first_node = self.nodes_id_list[1]
--     tree_state:setRunningNodeID(first_node.id)
--     return first_node
--   end

--   return tree_state:getCurrentNode(nodeID)
-- end

function Composite.run(tree_state)
    tree_state.runningNode.start(tree_state)
    tree_state.runningNode.run(tree_state)
end

function Composite.success(tree_state)
    tree_state.runningNode.finish(tree_state)
end

function Composite.fail(tree_state)
    tree_state.runningNode.finish(tree_state)
end

return Composite
