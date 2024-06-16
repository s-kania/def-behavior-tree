local Registry = require "def_behavior_tree.registry"
local Node  = require "def_behavior_tree.node_types.node"
local Composite = class("Composite", Node)

function Composite:start()
  self.actualTaskIndex = 1
end

function Composite:run()
  if self.actualTaskIndex <= #self.nodes_id_list then
    self:_run()
  end
end

function Composite:_run()
  local nodeID = self.nodes_id_list[self.actualTaskIndex]

  self.node = Registry.getNodeFromTree(nodeID, self.treeState)
  self.node:setParent(self)

  -- self.treeState:setRunningNodeID(nodeID)
  self.node:start(self.treeState.payload)
  self.node:run(self.treeState.payload)
end


function Composite:success()
  self.treeState.nodes_history[self.id] = {
    success = true,
    delay = node_show_delay,
  }

  self.node:finish(self.treeState.payload)
  self.node = nil
end

function Composite:fail()
  self.treeState.nodes_history[self.id] = {
    success = false,
    delay = node_show_delay,
  }

  self.node:finish(self.treeState.payload)
  self.node = nil
end

return Composite
