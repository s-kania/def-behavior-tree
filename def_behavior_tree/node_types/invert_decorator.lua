local Decorator  = require "def_behavior_tree.node_types.decorator"
local InvertDecorator = class("InvertDecorator", Decorator)

function InvertDecorator:success()
  Decorator.fail(self)
  self:getParent():fail()
end

function InvertDecorator:fail()
  Decorator.success(self)
  self:getParent():success()
end

return InvertDecorator
