local Decorator  = require "def_behavior_tree.node_types.decorator"

local function process(tree_state)
    Decorator.success(tree_state)
    tree_state:setActiveNode(tree_state.activeNode.parent)
    tree_state.activeNode.parent.success(tree_state)
end

local AlwaysSucceedDecorator = {
    name = "AlwaysSucceedDecorator",
    start = Decorator.start,
    run = Decorator.run,
    success = process,
    fail = process,
}

return AlwaysSucceedDecorator
