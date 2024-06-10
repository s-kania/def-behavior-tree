local BranchNode  = require "def_behavior_tree.node_types.branch_node"
local Priority = class("Priority", BranchNode)

function Priority:success()
  BranchNode.success(self)
  self.parent:success()
end

function Priority:fail()
  BranchNode.fail(self)
  self.actualTask = self.actualTask + 1
  if self.actualTask <= #self.nodes_id_list then
    self:_run()
  else
    self.parent:fail()
  end
end

return Priority
