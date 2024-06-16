local Composite  = require "def_behavior_tree.node_types.composite"
local RepeatUntilFail = class("RepeatUntilFail", Composite)

function RepeatUntilFail:success()
  Composite.success(self)
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
  Composite.fail(self)
  self.parent:success()
end

return RepeatUntilFail