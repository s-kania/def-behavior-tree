local Decorator  = require "def_behavior_tree.node_types.decorator"
local AlwaysFailDecorator = class("AlwaysFailDecorator", Decorator)

function AlwaysFailDecorator:success()
  self.treeState:getNode(self.parent_id):fail()
end

function AlwaysFailDecorator:fail()
  self.treeState:getNode(self.parent_id):fail()
end

return AlwaysFailDecorator

