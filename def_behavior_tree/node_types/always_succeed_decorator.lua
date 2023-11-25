local Decorator  = require "def_behavior_tree.node_types.decorator"
local AlwaysSucceedDecorator = class("AlwaysSucceedDecorator", Decorator)

function AlwaysSucceedDecorator:success()
  self.control:success()
end

function AlwaysSucceedDecorator:fail()
  self.control:success()
end

return AlwaysSucceedDecorator
