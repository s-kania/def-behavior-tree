local Decorator  = require "def_behavior_tree.node_types.decorator"
local AlwaysFailDecorator = class("AlwaysFailDecorator", Decorator)

function AlwaysFailDecorator:success()
  self:getParent():fail()
end

function AlwaysFailDecorator:fail()
  self:getParent():fail()
end

return AlwaysFailDecorator

