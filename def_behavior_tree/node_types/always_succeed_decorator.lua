local Decorator  = require "def_behavior_tree.node_types.decorator"
local AlwaysSucceedDecorator = class("AlwaysSucceedDecorator", Decorator)

function AlwaysSucceedDecorator:success()
  self.parent:success()
end

function AlwaysSucceedDecorator:fail()
  self.parent:success()
end

return AlwaysSucceedDecorator
