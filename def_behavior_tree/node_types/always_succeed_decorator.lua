local Decorator  = require "def_behavior_tree.node_types.decorator"
local AlwaysSucceedDecorator = class("AlwaysSucceedDecorator", Decorator)

function AlwaysSucceedDecorator:success()
  self:getParent():success()
end

function AlwaysSucceedDecorator:fail()
  self:getParent():success()
end

return AlwaysSucceedDecorator
