local Registry = require "def_behavior_tree.registry"
local Node  = require "def_behavior_tree.node_types.node"
local Composite = class("Composite", Node)

function Composite:start()
  self.actualTaskIndex = 1
end

-- w priority/sequence/repeat_until_fail uzywane jest _run aby pominac sprawdzanie actuaTaskIndex ktore jest wyzej
-- a jest wyzej bo jest tez warunek else
-- jednakze run tutaj moglby zwracac fail
-- wtedy nie byloby potrzeby posiadania dwóch funkcji
function Composite:run()
  if self.actualTaskIndex <= #self.nodes_id_list then
    self:_run()
  end
end

function Composite:_run()
  -- TODO w teori mozemy wyjebac actualTaskIndex i zamiast tego zrobic wyszukiwanie kolejnego node w liscie nodes_id_list,
  -- ewentualnie do zadania implementujemy informacje o nextNode, ale to chyba pierwsza opcja lepsza
  local nodeID = self.nodes_id_list[self.actualTaskIndex]

  self.node = Registry.getNodeFromTree(nodeID, self.treeState)
  self.node:setParent(self)

  -- self.treeState:setRunningNodeID(nodeID)
  self.node:start(self.treeState.payload)
  self.node:run(self.treeState.payload)
end


function Composite:success()
  self.node:finish(self.treeState.payload)
  self.node = nil
end

function Composite:fail()
  self.node:finish(self.treeState.payload)
  self.node = nil
end

return Composite
