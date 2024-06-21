local Decorator  = require "def_behavior_tree.node_types.decorator"
local InvertDecorator = class("InvertDecorator", Decorator)

function InvertDecorator:success()
  Decorator.fail(self)
  self.treeState:getNode(self.parent_id):fail()
end

function InvertDecorator:fail()
  Decorator.success(self)
  self.treeState:getNode(self.parent_id):success()
end

return InvertDecorator
