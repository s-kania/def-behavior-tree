-- local Registry = require "def_behavior_tree.registry"
-- local Node  = require "def_behavior_tree.node_types.node"
-- local Decorator = class("Decorator", Node)

-- function Decorator:success() end
-- function Decorator:fail() end

-- function Decorator:start()
--   self.node = self.treeState:getNode(self.node_id)
-- end

-- function Decorator:run()
--   self.node:start()
--   self.node:run()
-- end

-- function Decorator:finish()
--   self.node:finish()
-- end

-- return Decorator
local Decorator = {}

Decorator.name = "Decorator"

function Decorator.success(tree_state)
    tree_state:getCurrentNode().finish(tree_state)
end

function Decorator.fail(tree_state)
    tree_state:getCurrentNode().finish(tree_state)
end

function Decorator.start(tree_state)
    local decoratorNode = tree_state:getCurrentNode()
    tree_state:setRunningNodeID(decoratorNode.node_id)
end

function Decorator.run(tree_state)
    local node = tree_state:getCurrentNode()

    node.start(tree_state)
    node.run(tree_state)
end

-- function Decorator.finish(tree_state)
--     -- local decoratorNode = tree_state:getCurrentNode()
--     -- tree_state:setRunningNodeID(decoratorNode.node_id)
--     tree_state:getCurrentNode().finish(tree_state)
-- end

return Decorator
