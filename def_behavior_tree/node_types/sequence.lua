local Composite = require "def_behavior_tree.node_types.composite"
local Sequence = {
    name = "Sequence",
    start = Composite.start,
    run = Composite.run,
}

function Sequence.success(tree_state)
    Composite.success(tree_state)
    local nextNode = Composite.getNextNode(tree_state)

    if nextNode then
        tree_state:setActiveNode(nextNode)
        Sequence.run(tree_state)
    else
        tree_state:setActiveNode(tree_state.activeNode.parent)
        tree_state.activeNode.parent.success(tree_state)
    end
end

function Sequence.fail(tree_state)
    Composite.fail(tree_state)
    tree_state:setActiveNode(tree_state.activeNode.parent)
    tree_state.activeNode.parent.fail(tree_state)
end

return Sequence

