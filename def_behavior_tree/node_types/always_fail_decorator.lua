local Decorator = require "def_behavior_tree.node_types.decorator"

local function process(tree_state)
    Decorator.fail(tree_state)
    tree_state:setActiveNode(tree_state.activeNode.parent)
    tree_state.activeNode.parent.fail(tree_state)
end

local AlwaysFailDecorator = {
    name = "AlwaysFailDecorator",
    start = Decorator.start,
    run = Decorator.run,
    success = process,
    fail = process,
}

return AlwaysFailDecorator
