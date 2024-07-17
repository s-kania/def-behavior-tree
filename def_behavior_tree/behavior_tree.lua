local Registry      = require "def_behavior_tree.registry"
local BehaviorTree = {}
BehaviorTree.__index = BehaviorTree
 
BehaviorTree.Registry                   = Registry
BehaviorTree.Task                       = require "def_behavior_tree.node_types.node"
BehaviorTree.Composite                  = require "def_behavior_tree.node_types.composite"
BehaviorTree.Sequence                   = require "def_behavior_tree.node_types.sequence"
BehaviorTree.Selector                   = require "def_behavior_tree.node_types.selector"
BehaviorTree.Random                     = require "def_behavior_tree.node_types.random"
BehaviorTree.RandomWithChances          = require "def_behavior_tree.node_types.random_with_chances"
BehaviorTree.Decorator                  = require "def_behavior_tree.node_types.decorator"
BehaviorTree.InvertDecorator            = require "def_behavior_tree.node_types.invert_decorator"
BehaviorTree.AlwaysFailDecorator        = require "def_behavior_tree.node_types.always_fail_decorator"
BehaviorTree.AlwaysSucceedDecorator     = require "def_behavior_tree.node_types.always_succeed_decorator"
BehaviorTree.RepeatUntilFailDecorator   = require "def_behavior_tree.node_types.repeat_until_fail_decorator"
BehaviorTree.ChanceDecorator            = require "def_behavior_tree.node_types.chance_decorator"

BehaviorTree.registerTemplates = Registry.registerTemplates
BehaviorTree.getTreeTemplate = Registry.getTreeTemplate

function BehaviorTree:run(activeNodeID)
  if self.running then
    return
  else
    self.running = true
    local firstRunNode = self:getNode(activeNodeID or 1)
    self:setActiveNode(firstRunNode)
    firstRunNode.start(self)
    firstRunNode.run(self)
  end
end

function BehaviorTree:restart(activeNodeID)
  self.running = true

  local rootNode = self:getNode(activeNodeID or 1)
  self:setActiveNode(rootNode)
  rootNode.start(self)
  rootNode.run(self)
end

function BehaviorTree:setActiveNode(node)
  self.activeNode = node
end

function BehaviorTree:getNode(nodeID)
  return Registry.getNodeFromTree(nodeID, self.name)
end

function BehaviorTree:success()
  local rootNode = self:getNode(1)
  rootNode.finish(self)
  self.running = false
end

function BehaviorTree:fail()
  local rootNode = self:getNode(1)
  rootNode.finish(self)
  self.running = false
end

function BehaviorTree:getRandomBetween(x, y)
  return self.rng(x, y)
end

function BehaviorTree.new(config)
  local self = setmetatable({
    name = config.tree_name,
    payload = config.payload,
    rng = config.rng or math.random,
    running = false,
  }, BehaviorTree)
  return self
end

return BehaviorTree
