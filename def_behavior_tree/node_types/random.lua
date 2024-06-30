local Composite = require "def_behavior_tree.node_types.composite"
local Random = {
    name = "Random",
    run = Composite.run,
}

function Random.start(tree_state)
    local random_index = tree_state:getRandomBetween(1, #tree_state.activeNode.nodes)
    tree_state:setActiveNode(tree_state.activeNode.nodes[random_index])
end

function Random.success(tree_state)
    Composite.success(tree_state)
    tree_state:setActiveNode(tree_state.activeNode.parent)
    tree_state.activeNode.parent.success(tree_state)
end

function Random.fail(tree_state)
    Composite.fail(tree_state)
    tree_state:setActiveNode(tree_state.activeNode.parent)
    tree_state.activeNode.parent.fail(tree_state)
end

return Random
