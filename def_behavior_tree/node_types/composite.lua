local Composite = {}

Composite.name = "Composite"

function Composite.run(tree_state)
    tree_state.runningNode.start(tree_state)
    tree_state.runningNode.run(tree_state)
end

function Composite.success(tree_state)
    tree_state.runningNode.finish(tree_state)
end

function Composite.fail(tree_state)
    tree_state.runningNode.finish(tree_state)
end

return Composite
