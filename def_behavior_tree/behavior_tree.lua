local Registry      = require "def_behavior_tree.registry"
local BehaviorTree = {}
BehaviorTree.__index = BehaviorTree
 
BehaviorTree.Registry                   = Registry
BehaviorTree.Task                       = require "def_behavior_tree.node_types.node"
BehaviorTree.Composite                  = require "def_behavior_tree.node_types.composite"
BehaviorTree.Sequence                   = require "def_behavior_tree.node_types.sequence"
-- BehaviorTree.Selector                   = require "def_behavior_tree.node_types.selector"
BehaviorTree.Random                     = require "def_behavior_tree.node_types.random"
BehaviorTree.RandomWithChances          = require "def_behavior_tree.node_types.random_with_chances"
BehaviorTree.Decorator                  = require "def_behavior_tree.node_types.decorator"
BehaviorTree.InvertDecorator            = require "def_behavior_tree.node_types.invert_decorator"
BehaviorTree.AlwaysFailDecorator        = require "def_behavior_tree.node_types.always_fail_decorator"
BehaviorTree.AlwaysSucceedDecorator     = require "def_behavior_tree.node_types.always_succeed_decorator"
BehaviorTree.RepeatUntilFailDecorator   = require "def_behavior_tree.node_types.repeat_until_fail_decorator"

BehaviorTree.registerTemplates = Registry.registerTemplates
BehaviorTree.getTreeTemplate = Registry.getTreeTemplate

BehaviorTree.version = "1.0.0"

function BehaviorTree:run()
  if self.running then
    return
  else
    self.running = true
    self.rootNode = self:getNode(1)

    self:setActiveNode(self.rootNode)
    self.rootNode.start(self)
    self.rootNode.run(self)
  end
end

-- TODO refactor?
-- function BehaviorTree:restart()
--     self:fail()
--     -- self.tree_state:setRunningNodeID(1)
--     self.running = true

--     self.rootNode:start()
--     self.rootNode:run()
-- end

function BehaviorTree:treeSuccess()
  self.rootNode.finish(self)
  self.running = false
end

function BehaviorTree:treeFail()
  self.rootNode.finish(self)
  self.running = false
end

function BehaviorTree:setActiveNode(node)
    self.activeNode = node
end

function BehaviorTree:getNode(nodeID)
    return Registry.getNodeFromTree(nodeID, self.name)
end

function BehaviorTree:success()
    self.activeNode.success(self)
end

function BehaviorTree:fail()
    self.activeNode.fail(self)
end

function BehaviorTree:getRandomBetween(x, y)
    if self.rng then
        return self.rng(x, y)
    end
    return math.random(x, y)
end

function BehaviorTree.new(config)
	local self = setmetatable({
        name = config.tree_name,
        payload = config.payload,
        rng = config.rng,
        activeNode = nil,
        running = false,
        rootNode = nil,
    }, BehaviorTree)
    return self
end

return BehaviorTree
