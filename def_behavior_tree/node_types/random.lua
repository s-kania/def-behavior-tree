local BranchNode  = require "def_behavior_tree.node_types.branch_node"
local Random = class("Random", BranchNode)

function Random:start(payload)
  BranchNode.start(self, payload)
  -- TODO rnd nie ma w tej paczce
  local random_number = rnd.range(1, self.cumulativeChances[#self.cumulativeChances])

  for index = 1, #self.nodes_id_list do
    if self.cumulativeChances[index] >= random_number then
      self.actualTask = index
      break -- TODO moze tutaj jest blad z BT i tym break
    end
  end
end

function Random:success()
  BranchNode.success(self)
  self.parent:success()
end

function Random:fail()
  BranchNode.fail(self)
  self.parent:fail()
end

return Random
