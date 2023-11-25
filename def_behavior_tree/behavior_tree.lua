local class         = require "def_behavior_tree.middleclass"
local Registry      = require "def_behavior_tree.registry"
local Node          = require "def_behavior_tree.node_types.node"
local BehaviorTree = class("BehaviorTree", Node)
 
BehaviorTree.Node                    = Node
BehaviorTree.Registry                = Registry
BehaviorTree.Task                    = Node
BehaviorTree.BranchNode              = require "def_behavior_tree.node_types.branch_node"
BehaviorTree.Priority                = require "def_behavior_tree.node_types.priority"
BehaviorTree.ActivePriority          = require "def_behavior_tree.node_types.active_priority"
BehaviorTree.Random                  = require "def_behavior_tree.node_types.random"
BehaviorTree.Sequence                = require "def_behavior_tree.node_types.sequence"
BehaviorTree.Decorator               = require "def_behavior_tree.node_types.decorator"
BehaviorTree.InvertDecorator         = require "def_behavior_tree.node_types.invert_decorator"
BehaviorTree.AlwaysFailDecorator     = require "def_behavior_tree.node_types.always_fail_decorator"
BehaviorTree.AlwaysSucceedDecorator  = require "def_behavior_tree.node_types.always_succeed_decorator"
BehaviorTree.RepeatUntilFail         = require "def_behavior_tree.node_types.repeat_until_fail"

BehaviorTree.register = Registry.register
BehaviorTree.getNode = Registry.getNode

function BehaviorTree:initialize(config)
  Node.initialize(self, config)
  if type(self.tree) == "string" then
    self.tree = Registry.getNode(self.tree)
  end
end

function BehaviorTree:run(object)
  if self.started then
    Node.running(self) --call running if we have control
  else
    self.started = true
    self.object = object or self.object
    self.rootNode = Registry.getNode(self.tree)
    self.rootNode:setControl(self)
    self.rootNode:start(self.object)
    self.rootNode:call_run(self.object)
  end
end

function BehaviorTree:restart()
    self:fail()
    self.started = true
    self.rootNode:setControl(self)
    self.rootNode:start(self.object)
    self.rootNode:call_run(self.object)
end

function BehaviorTree:running()
  Node.running(self)
  self.started = false
end

function BehaviorTree:success()
  self.rootNode:finish(self.object);
  self.started = false
  Node.success(self)
end

function BehaviorTree:fail()
  self.rootNode:finish(self.object);
  self.started = false
  Node.fail(self)
end

return BehaviorTree
