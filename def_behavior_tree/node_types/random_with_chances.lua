local Composite = require "def_behavior_tree.node_types.composite"
local RandomWithChances = {
    name = "RandomWithChances",
    run = Composite.run,
}

function RandomWithChances.start(tree_state)
    local random_number = tree_state:getRandomBetween(1, 100)
    local current_chance = 0
    for _, node in ipairs(tree_state.activeNode.nodes) do
        current_chance = current_chance + node.chance
        if random_number <= current_chance then
            return tree_state:setActiveNode(node)
        end
    end
end

function RandomWithChances.success(tree_state)
    Composite.success(tree_state)
    tree_state:setActiveNode(tree_state.activeNode.parent)
    tree_state.activeNode.parent.success(tree_state)
end

function RandomWithChances.fail(tree_state)
    Composite.fail(tree_state)
    tree_state:setActiveNode(tree_state.activeNode.parent)
    tree_state.activeNode.parent.fail(tree_state)
end

return RandomWithChances
