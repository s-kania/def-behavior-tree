local Registry = require "def_behavior_tree.registry"
local Node  = require "def_behavior_tree.node_types.node"
local Decorator = class("Decorator", Node)

function Decorator:success() end
function Decorator:fail() end

function Decorator:start()
  self.node = self.treeState:getNode(self.node_id)
  self.node:setParent(self)
end

function Decorator:run()
  self.node:start()
  self.node:run()
end

function Decorator:finish()
  self.node:finish()
end

return Decorator
