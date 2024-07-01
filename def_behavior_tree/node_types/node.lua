local Node = {
    name = "Node"
}

local function getNodeArgs(tree_state)
    return {
        success = function () tree_state.activeNode.success(tree_state) end,
        fail = function () tree_state.activeNode.fail(tree_state) end,
    }, tree_state.payload
end

function Node.start(tree_state)
    tree_state.activeNode._start(getNodeArgs(tree_state))
end

function Node.run(tree_state)
    tree_state.activeNode._run(getNodeArgs(tree_state))
end

function Node.finish(tree_state)
    tree_state.activeNode._finish(getNodeArgs(tree_state))
end

function Node.success(tree_state)
    tree_state.activeNode.parent.success(tree_state)
end

function Node.fail(tree_state)
    tree_state.activeNode.parent.fail(tree_state)
end

return Node