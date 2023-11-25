local Registry = require "def_behavior_tree.registry"
local Node  = require "def_behavior_tree.node_types.node"
local BranchNode = class("BranchNode", Node)

function BranchNode:start(object)
  if not self.nodeRunning then
    self:setObject(object)
    self.actualTask = 1
  end
end

function BranchNode:run(object)
  if self.actualTask <= #self.nodes then
    self:_run(object)
  end
end

function BranchNode:_run(object)
  if not self.nodeRunning then
    local node = self.nodes[self.actualTask]
    self.node = Registry.getNode(node)
    if type(node) == "string" then
      self.nodes[self.actualTask] = self.node
    end
    self.node:start(object)
    self.node:setControl(self)
  end
  self.node:run(object)
end

function BranchNode:running()
  self.nodeRunning = true
  self.control:running()
end

function BranchNode:success()
  self.nodeRunning = false
  self.node:finish(self.object)
  self.node = nil
end

function BranchNode:fail()
  self.nodeRunning = false
  self.node:finish(self.object);
  self.node = nil
end

return BranchNode
