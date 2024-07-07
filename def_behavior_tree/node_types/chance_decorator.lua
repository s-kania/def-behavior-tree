local Decorator  = require "def_behavior_tree.node_types.decorator"
local ChanceDecorator = {
    name = "ChanceDecorator",
    start = Decorator.start,
    run = Decorator.run,
}

function ChanceDecorator.success(tree_state)
    Decorator.success(tree_state)
    tree_state:setActiveNode(tree_state.activeNode.parent)
    tree_state.activeNode.parent.success(tree_state)
end

function ChanceDecorator.fail(tree_state)
    Decorator.fail(tree_state)
    tree_state:setActiveNode(tree_state.activeNode.parent)
    tree_state.activeNode.parent.fail(tree_state)
end

return ChanceDecorator
