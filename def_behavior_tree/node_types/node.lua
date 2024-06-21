local Node      = class("Node")

function Node:initialize(config)
  config = config or {}
  for k, v in pairs(config) do
    self[k] = v
  end
end

function Node:_startTask(payload) end
function Node:_runTask(payload) end
function Node:_finishTask(payload) end

function Node:start()
  self._startTask(self, self.treeState.payload)
end

function Node:run()
  self._runTask(self, self.treeState.payload)
end

function Node:finish()
  self._finishTask(self, self.treeState.payload)
end

function Node:success()
  self:getParent():success()
end

function Node:fail()
  self:getParent():fail()
end

function Node:getParent()
  return self.treeState:getNode(self.parent_id)
end

return Node
