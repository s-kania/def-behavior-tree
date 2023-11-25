local Decorator  = require "def_behavior_tree.node_types.decorator"
local AlwaysFailDecorator = class("AlwaysFailDecorator", Decorator)

function AlwaysFailDecorator:success()
  self.control:fail()
end

function AlwaysFailDecorator:fail()
  self.control:fail()
end

return AlwaysFailDecorator

