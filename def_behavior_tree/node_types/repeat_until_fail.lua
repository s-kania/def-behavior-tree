local BranchNode  = require "def_behavior_tree.node_types.branch_node"
local RepeatUntilFail = class("RepeatUntilFail", BranchNode)

function RepeatUntilFail:success()
  self.actualTask = self.actualTask + 1
  if self.actualTask <= #self.nodes then
    self:_run(self.object)
  else
    self.actualTask = 1
    self:_run(self.object)
  end
end

function RepeatUntilFail:fail()
  BranchNode.success(self)
  self.control:success()
end

return RepeatUntilFail