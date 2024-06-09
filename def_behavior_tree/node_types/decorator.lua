local Registry = require "def_behavior_tree.registry"
local Node  = require "def_behavior_tree.node_types.node"
local Decorator = class("Decorator", Node)


function Decorator:start(payload)
  self.treeState:setRunningNodeIndex(self.node_id)

  self.node = Registry.getNodeFromTree(self.treeState)
  self.node:start(payload)
end

function Decorator:finish(payload)
  self.treeState:setRunningNodeIndex(self.node_id)

  self.node = Registry.getNodeFromTree(self.treeState)
  self.node:finish(payload)
end

function Decorator:run(payload)
  self.treeState:setRunningNodeIndex(self.node_id)

  self.node = Registry.getNodeFromTree(self.treeState)
  self.node:setParent(self)
  self.node:run(payload)
end

return Decorator
