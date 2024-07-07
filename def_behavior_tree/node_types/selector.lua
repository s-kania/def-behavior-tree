local Composite = require "def_behavior_tree.node_types.composite"
local Selector = {
    name = "Selector",
    start = Composite.start,
    run = Composite.run,
}

function Selector.success(tree_state)
    Composite.success(tree_state)
    tree_state:setActiveNode(tree_state.activeNode.parent)
    tree_state.activeNode.parent.success(tree_state)
end

function Selector.fail(tree_state)
    Composite.fail(tree_state)
    local nextNode = Composite.getNextNode(tree_state)

    if nextNode then
        tree_state:setActiveNode(nextNode)
        Selector.run(tree_state)
    else
        tree_state:setActiveNode(tree_state.activeNode.parent)
        tree_state.activeNode.parent.fail(tree_state)
    end
end

return Selector
