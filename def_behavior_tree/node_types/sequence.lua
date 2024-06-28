local Composite = require "def_behavior_tree.node_types.composite"
local Sequence = {}

Sequence.name = "Sequence"

function Sequence.getNextNode(tree_state)
    local sequenceNode = tree_state.runningNode.parent
    local currentNodeIndex = nil

    for index, node in ipairs(sequenceNode.nodes) do
        if node.id == tree_state.runningNode.id then
            currentNodeIndex = index
            break
        end
    end

    return sequenceNode.nodes[currentNodeIndex + 1]
end

function Sequence.start(tree_state)
    local nextNode = tree_state.runningNode.nodes[1]
    tree_state:setRunningNode(nextNode)
end

function Sequence.run(tree_state)
     Composite.run(tree_state)
end

function Sequence.success(tree_state)
    Composite.success(tree_state)
    local nextNode = Sequence.getNextNode(tree_state)

    if nextNode then
        tree_state:setRunningNode(nextNode)
        Composite.run(tree_state)
    else
        local sequenceNode = tree_state.runningNode.parent
        tree_state:setRunningNode(sequenceNode)
        tree_state.runningNode.parent.success(tree_state)
    end
end

function Sequence.fail(tree_state)
    Composite.fail(tree_state)
    local sequenceNode = tree_state.runningNode.parent
    tree_state:setRunningNode(sequenceNode)
    tree_state.runningNode.parent.fail(tree_state)
end

return Sequence

