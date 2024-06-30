local Node = {
    name = "Node"
}

function Node.start(tree_state) end
function Node.run(tree_state) end
function Node.finish(tree_state) end

function Node.success(tree_state)
    tree_state.activeNode.parent.success(tree_state)
end

function Node.fail(tree_state)
    tree_state.activeNode.parent.fail(tree_state)
end

return Node