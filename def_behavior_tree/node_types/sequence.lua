local Composite  = require "def_behavior_tree.node_types.composite"
local Sequence = class("Sequence", Composite)

function Sequence:success()
  Composite.success(self)
  self.actualTaskIndex = self.actualTaskIndex + 1
  if self.actualTaskIndex <= #self.nodes_id_list then
    self:_run()
  else
    self:getParent():success()
  end
end

function Sequence:fail()
  Composite.fail(self)
  self:getParent():fail()
end

return Sequence
