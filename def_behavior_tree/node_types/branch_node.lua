local Registry = require "def_behavior_tree.registry"
local Node  = require "def_behavior_tree.node_types.node"
local BranchNode = class("BranchNode", Node)

function BranchNode:start()
  self.actualTask = 1
end

function BranchNode:run()
  if self.actualTask <= #self.nodes_id_list then
    self:_run()
  end
end

function BranchNode:_run()
  local nodeIndex = self.nodes_id_list[self.actualTask]
  self.treeState:setRunningNodeIndex(nodeIndex) -- TODO ustawianie running node w node lub branch node po odpaleniu

  self.node = Registry.getNodeFromTree(self.treeState)
  self.node:setParent(self)

  self.node:start(self.treeState.payload)
  self.node:run(self.treeState.payload)
end


function BranchNode:success()
  self.treeState.nodes_history[self._index] = {
    success = true,
    delay = node_show_delay,
  }

  self.node:finish(self.treeState.payload)
  self.node = nil
end

function BranchNode:fail()
  self.treeState.nodes_history[self._index] = {
    success = false,
    delay = node_show_delay,
  }

  self.node:finish(self.treeState.payload)
  self.node = nil
end

return BranchNode
