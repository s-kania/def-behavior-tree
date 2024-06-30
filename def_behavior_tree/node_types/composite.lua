local Composite = {}

Composite.name = "Composite"

function Composite.getNextNode(tree_state)
    local compositeNode = tree_state.activeNode.parent

    for index, node in ipairs(compositeNode.nodes) do
        if node.id == tree_state.activeNode.id then
            return compositeNode.nodes[index + 1]
        end
    end
end

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
