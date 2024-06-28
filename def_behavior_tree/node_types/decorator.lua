local Decorator = {}

Decorator.name = "Decorator"

function Decorator.start(tree_state)
    local decoratorChild = tree_state.runningNode.node
    tree_state:setRunningNode(decoratorChild)
end

function Decorator.run(tree_state)
    tree_state.runningNode.start(tree_state)
    tree_state.runningNode.run(tree_state)
end

function Decorator.success(tree_state)
    tree_state.runningNode.finish(tree_state)
end

function Decorator.fail(tree_state)
    tree_state.runningNode.finish(tree_state)
end

return Decorator
