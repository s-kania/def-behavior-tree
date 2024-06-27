-- local Decorator  = require "def_behavior_tree.node_types.decorator"
-- local RepeatUntilFailDecorator = class("RepeatUntilFailDecorator", Decorator)

-- function RepeatUntilFailDecorator:success()
--     Decorator.run(self)
-- end

-- function RepeatUntilFailDecorator:fail()
--     Decorator.success(self)
--     self:getParent():success()
-- end

-- return RepeatUntilFailDecorator

local Decorator  = require "def_behavior_tree.node_types.decorator"

local RepeatUntilFailDecorator = {
    name = "RepeatUntilFailDecorator",
    start = Decorator.start,
    run = Decorator.run,
    finish = Decorator.finish,
}

function RepeatUntilFailDecorator.success(tree_state)
    -- Decorator.success(tree_state)
    Decorator.run(tree_state)
end

function RepeatUntilFailDecorator.fail(tree_state)
    Decorator.fail(tree_state)
    local repeatUntilFailDecoratorNode = tree_state:getCurrentNodeParent()
    tree_state:setRunningNode(repeatUntilFailDecoratorNode)
    tree_state:getCurrentNodeParent().success(tree_state)
end

return RepeatUntilFailDecorator
