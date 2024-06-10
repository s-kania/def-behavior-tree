local Node      = class("Node")

function Node:initialize(config)
  config = config or {}
  for k, v in pairs(config) do
    self[k] = v
  end
end

function Node:start() end
function Node:finish() end
function Node:run() end

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
