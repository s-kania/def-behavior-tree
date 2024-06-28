local Node = {}

Node.name = "Node"

function Node.start(tree_state) end
function Node.run(tree_state) end
function Node.finish(tree_state) end

function Node.success(tree_state)
    tree_state.runningNode.parent.success(tree_state)
end

function Node.fail(tree_state)
    tree_state.runningNode.parent.fail(tree_state)
end

return Node