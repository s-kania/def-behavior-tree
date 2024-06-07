local BranchNode  = require "def_behavior_tree.node_types.branch_node"
local RepeatUntilFail = class("RepeatUntilFail", BranchNode)

function RepeatUntilFail:success()
  -- łatwo przypisac aktualny actualTask sprawdzajas dlugosc listy childs z poziomu dziecka jesli wczytujemy na żądanie
  self.actualTask = self.actualTask + 1
  if self.actualTask <= #self.nodes then
    self:_run(self.payload)
  else
    self.actualTask = 1
    self:_run(self.payload)
  end
end

function RepeatUntilFail:fail()
  BranchNode.success(self)
  self.parent:success()
end

return RepeatUntilFail