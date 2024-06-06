local Registry = require "def_behavior_tree.registry"
local Node  = require "def_behavior_tree.node_types.node"
local BranchNode = class("BranchNode", Node)

function BranchNode:start(payload)
  if not self.nodeRunning then
    self:setPayload(payload)
    self.actualTask = 1
  end
end

function BranchNode:run(payload)
  if self.actualTask <= #self.nodes then
    self:_run(payload)
  end
end

function BranchNode:_run(payload)
  if not self.nodeRunning then
    local node = self.nodes[self.actualTask]
    self.node = Registry.getNode(node)
    if type(node) == "string" then
      self.nodes[self.actualTask] = self.node
    end
    self.node:start(payload)
    self.node:setParent(self)
  end
  self.node:run(payload)
end


function BranchNode:success()
  self.nodeRunning = false
  self.node:finish(self.payload)
  self.node = nil
end

function BranchNode:fail()
  self.nodeRunning = false
  self.node:finish(self.payload);
  self.node = nil
end

return BranchNode
