local Decorator  = require "def_behavior_tree.node_types.decorator"
local InvertDecorator = {
    name = "InvertDecorator",
    start = Decorator.start,
    run = Decorator.run,
}

function InvertDecorator.success(tree_state)
    Decorator.fail(tree_state)
    local invertDecoratorNode = tree_state.runningNode.parent
    tree_state:setRunningNode(invertDecoratorNode)
    tree_state.runningNode.parent.fail(tree_state)
end

function InvertDecorator.fail(tree_state)
    Decorator.success(tree_state)
    local invertDecoratorNode = tree_state.runningNode.parent
    tree_state:setRunningNode(invertDecoratorNode)
    tree_state.runningNode.parent.success(tree_state)
end

return InvertDecorator
