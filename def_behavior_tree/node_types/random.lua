local Composite  = require "def_behavior_tree.node_types.composite"
local Random = class("Random", Composite)

function Random:start(payload)
  Composite.start(self, payload)

  if self.chances then
    if not self.cumulativeChances then
      local cumulativeChances = {}
      
      for i = 1, #self.chances do
        cumulativeChances[i] = self.chances[i] + (cumulativeChances[i - 1] or 0)
      end

      self.cumulativeChances = cumulativeChances
    end

    self.cumulativeChances = self.cumulativeChances
  end

  -- TODO rnd nie ma w tej paczce
  local random_number = rnd.range(1, self.cumulativeChances[#self.cumulativeChances])

  for index = 1, #self.nodes_id_list do
    if self.cumulativeChances[index] >= random_number then
      self.actualTaskIndex = index
      break -- TODO moze tutaj jest blad z BT i tym break
    end
  end
end

function Random:success()
  Composite.success(self)
  self.parent:success()
end

function Random:fail()
  Composite.fail(self)
  self.parent:fail()
end

return Random
