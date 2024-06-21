local Node      = class("Node")

function Node:initialize(config)
  config = config or {}
  for k, v in pairs(config) do
    self[k] = v
  end
end

function Node:_start(payload) end
function Node:_run(payload) end
function Node:_finish(payload) end

function Node:start()
  self._start(self, self.treeState.payload)
end

function Node:run()
  self._run(self, self.treeState.payload)
end

function Node:finish()
  self._finish(self, self.treeState.payload)
end

function Node:setParent(parent)
  self.parent = parent
end

function Node:success()
  if self.parent then
    self.parent:success()
  end
end

function Node:fail()
  if self.parent then
    self.parent:fail()
  end
end

return Node
