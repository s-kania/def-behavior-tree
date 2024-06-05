local Decorator  = require "def_behavior_tree.node_types.decorator"
local InvertDecorator = class("InvertDecorator", Decorator)

function InvertDecorator:success()
  self.parent:fail()
end

function InvertDecorator:fail()
  self.parent:success()
end

return InvertDecorator
