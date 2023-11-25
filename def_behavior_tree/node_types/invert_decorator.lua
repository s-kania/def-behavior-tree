local Decorator  = require "def_behavior_tree.node_types.decorator"
local InvertDecorator = class("InvertDecorator", Decorator)

function InvertDecorator:success()
  self.control:fail()
end

function InvertDecorator:fail()
  self.control:success()
end

return InvertDecorator
