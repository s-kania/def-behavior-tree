local Decorator  = require "def_behavior_tree.node_types.decorator"
local AlwaysSucceedDecorator = class("AlwaysSucceedDecorator", Decorator)

function AlwaysSucceedDecorator:success()
  self.treeState:getNode(self.parent_id):success()
end

function AlwaysSucceedDecorator:fail()
  self.treeState:getNode(self.parent_id):success()
end

return AlwaysSucceedDecorator
