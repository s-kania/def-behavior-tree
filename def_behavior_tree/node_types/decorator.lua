local Decorator = {
    name = "Decorator"
}

function Decorator.start(tree_state)
    tree_state:setActiveNode(tree_state.activeNode.node)
end

function Decorator.run(tree_state)
    tree_state.activeNode.start(tree_state)
    tree_state.activeNode.run(tree_state)
end

function Decorator.success(tree_state)
    tree_state.activeNode.finish(tree_state)
end

function Decorator.fail(tree_state)
    tree_state.activeNode.finish(tree_state)
end

return Decorator
