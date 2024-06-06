local Registry = require "def_behavior_tree.registry"
local Node  = require "def_behavior_tree.node_types.node"
local Decorator = class("Decorator", Node)

function Decorator:initialize(config)
  Node.initialize(self, config)
  self.node = Registry.getNode(self.node)
end

function Decorator:setNode(node)
  self.node = Registry.getNode(node)
end

function Decorator:start(payload)
  self.node:start(payload)
end

function Decorator:finish(payload)
  self.node:finish(payload)
end

function Decorator:run(payload)
  self.node:setParent(self)
  self.node:run(payload)
end

return Decorator
