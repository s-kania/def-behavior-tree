local Registry = require "def_behavior_tree.registry"
local Node  = require "def_behavior_tree.node_types.node"
local Decorator = class("Decorator", Node)

-- TODO sprawdzc czy dekorator potrzebuje wszystkich funkcji
function Decorator:start(payload)
  self.node = Registry.getNodeFromTree(self.node_id, self.treeState)

  self.treeState:setRunningNodeID(self.node_id)
  self.node:start(payload)
end

function Decorator:run(payload)
  self.node = Registry.getNodeFromTree(self.node_id, self.treeState)
  self.node:setParent(self)

  self.treeState:setRunningNodeID(self.node_id)
  self.node:run(payload)
end

function Decorator:finish(payload)
  self.node = Registry.getNodeFromTree(self.node_id, self.treeState)

  self.treeState:setRunningNodeID(self.node_id)
  self.node:finish(payload)
end

return Decorator
