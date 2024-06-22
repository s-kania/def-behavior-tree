local Decorator  = require "def_behavior_tree.node_types.decorator"
local RepeatUntilFailDecorator = class("RepeatUntilFailDecorator", Decorator)

function RepeatUntilFailDecorator:success()
  Decorator.run(self)
end

function RepeatUntilFailDecorator:fail()
  Decorator.success(self)
  self:getParent():success()
end

return RepeatUntilFailDecorator
