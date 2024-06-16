local BranchNode  = require "def_behavior_tree.node_types.branch_node"
local RepeatUntilFail = class("RepeatUntilFail", BranchNode)

function RepeatUntilFail:success()
  BranchNode.success(self)
  -- łatwo przypisac aktualny actualTask sprawdzajas dlugosc listy childs z poziomu dziecka jesli wczytujemy na żądanie
  self.actualTaskIndex = self.actualTaskIndex + 1
  if self.actualTaskIndex <= #self.nodes_id_list then
    self:_run()
  else
    self.actualTaskIndex = 1
    self:_run()
  end
end

function RepeatUntilFail:fail()
  BranchNode.fail(self)
  self.parent:success()
end

return RepeatUntilFail