local BranchNode  = require "def_behavior_tree.node_types.branch_node"
local Sequence = class("Sequence", BranchNode)

function Sequence:success()
  BranchNode.success(self)
  self.actualTask = self.actualTask + 1
  if self.actualTask <= #self.nodes_id_list then
    self:_run()
  else
    self.parent:success()
  end
end

function Sequence:fail()
  BranchNode.fail(self)
  self.parent:fail()
end

return Sequence
