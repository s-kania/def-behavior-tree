local Registry = require "def_behavior_tree.registry"
local Node  = require "def_behavior_tree.node_types.node"
local Decorator = class("Decorator", Node)

function Decorator:start(payload)
  self.node = Registry.getNodeFromTree(self.node_id, self.treeState)
  self.node:setParent(self)
end

function Decorator:run(payload)
  self.node:start(payload)
  self.node:run(payload)
end

function Decorator:finish(payload)
  self.node:finish(payload)
end

return Decorator
