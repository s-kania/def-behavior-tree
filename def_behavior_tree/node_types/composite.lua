local Composite = {}

Composite.name = "Composite"

function Composite.start(tree_state)
    tree_state:setActiveNode(tree_state.activeNode.nodes[1])
end

function Composite.run(tree_state)
    tree_state.activeNode.start(tree_state)
    tree_state.activeNode.run(tree_state)
end

function Composite.success(tree_state)
    tree_state.activeNode.finish(tree_state)
end

function Composite.fail(tree_state)
    tree_state.activeNode.finish(tree_state)
end

return Composite
