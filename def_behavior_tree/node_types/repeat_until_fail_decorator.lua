local Decorator = require "def_behavior_tree.node_types.decorator"

local RepeatUntilFailDecorator = {
    name = "RepeatUntilFailDecorator",
    start = Decorator.start,
    run = Decorator.run,
    finish = Decorator.finish,
}

function RepeatUntilFailDecorator.success(tree_state)
    Decorator.success(tree_state)
    Decorator.run(tree_state)
end

function RepeatUntilFailDecorator.fail(tree_state)
    Decorator.fail(tree_state)
    tree_state:setActiveNode(tree_state.activeNode.parent)
    tree_state.activeNode.parent.success(tree_state)
end

return RepeatUntilFailDecorator

