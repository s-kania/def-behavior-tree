local Composite  = require "def_behavior_tree.node_types.composite"
local Priority = class("Priority", Composite)

function Priority:success()
  Composite.success(self)
  self.treeState:getNode(self.parent_id):success()
end

function Priority:fail()
  Composite.fail(self)
  self.actualTaskIndex = self.actualTaskIndex + 1
  if self.actualTaskIndex <= #self.nodes_id_list then
    self:_run()
  else
    self.treeState:getNode(self.parent_id):fail()
  end
end

return Priority
