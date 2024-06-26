local Decorator  = require "def_behavior_tree.node_types.decorator"
local InvertDecorator = {
    name = "InvertDecorator",
    start = Decorator.start,
    run = Decorator.run,
    finish = Decorator.finish,
}

function InvertDecorator.success(tree_state)
    Decorator.fail(tree_state)
    local invertDecoratorNode = tree_state:getCurrentNodeParent()
    tree_state:setRunningNodeID(invertDecoratorNode.id)
    tree_state:getCurrentNodeParent().fail(tree_state)
end

function InvertDecorator.fail(tree_state)
    Decorator.success(tree_state)
    local invertDecoratorNode = tree_state:getCurrentNodeParent()
    tree_state:setRunningNodeID(invertDecoratorNode.id)
    tree_state:getCurrentNodeParent().success(tree_state)
end

return InvertDecorator
