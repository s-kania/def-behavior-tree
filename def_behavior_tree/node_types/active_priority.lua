local Registry = require "def_behavior_tree.registry"
local Priority  = require "def_behavior_tree.node_types.priority"
local ActivePriority = class("ActivePriority", Priority)

function ActivePriority:success()
  self:_finishRunningNode()
  self.runningTask = nil
  Priority.success(self)
end

function ActivePriority:fail()
  if self.runningTask == self.actualTask then
    -- The previously-running task just failed
    self.runningTask = nil
  end
  Priority.fail(self)
end


function ActivePriority:_finishRunningNode()
  if self.runningTask and self.runningTask > self.actualTask then
    local runningNode = Registry.getNode(self.nodes[self.runningTask]) 
    runningNode:finish()
  end
end

return ActivePriority
