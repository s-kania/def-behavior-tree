local Decorator  = require "def_behavior_tree.node_types.decorator"
local AlwaysFailDecorator = class("AlwaysFailDecorator", Decorator)

function AlwaysFailDecorator:success()
  self.parent:fail()
end

function AlwaysFailDecorator:fail()
  self.parent:fail()
end

return AlwaysFailDecorator

