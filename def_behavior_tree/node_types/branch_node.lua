local Registry = require "def_behavior_tree.registry"
local Node  = require "def_behavior_tree.node_types.node"
local BranchNode = class("BranchNode", Node)

function BranchNode:start(payload)
  self:setPayload(payload)
  self.actualTask = 1
end

function BranchNode:run(payload)
  if self.actualTask <= #self.nodes_id_list then
    self:_run(payload)
  end
end

function BranchNode:_run(payload)
  local nodeIndex = self.nodes_id_list[self.actualTask]
  self.treeState:setRunningNodeIndex(nodeIndex)

  self.node = Registry.getNodeFromTree(self.treeState)

  self.node:start(payload)
  self.node:setParent(self)
  self.node:run(payload)
end


function BranchNode:success()
  self.node:finish(self.payload)
  self.node = nil
end

function BranchNode:fail()
  self.node:finish(self.payload);
  self.node = nil
end

return BranchNode
