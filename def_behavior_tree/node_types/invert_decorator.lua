local Decorator  = require "def_behavior_tree.node_types.decorator"
local InvertDecorator = class("InvertDecorator", Decorator)

function InvertDecorator:success()
  self.treeState.nodes_history[self._index] = {
    success = false,
    delay = node_show_delay,
  }
  self.parent:fail()
end

function InvertDecorator:fail()
  self.treeState.nodes_history[self._index] = {
    success = true,
    delay = node_show_delay,
  }
  self.parent:success()
end

return InvertDecorator
