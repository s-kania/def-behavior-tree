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

BehaviorTree.registerTemplates = Registry.registerTemplates
BehaviorTree.getTreeTemplate = Registry.getTreeTemplate

BehaviorTree.version = "1.0.0"

function BehaviorTree:initialize(config)
  Node.initialize(self, config)
  self.treeState = {
    name = config.treeName,
    payload = config.payload,
    runningNodeIndex = 1,
    setRunningNodeIndex = function(self, index)
      self.runningNodeIndex = index
    end,
    nodes_history = {}
    -- TODO callback, jedno drzewo moze miec tylko jednego callbacka aktualnego
    -- ale statek moze plynac a drzewo robic inna akcje, np atakowac, wtedy callback plyniecia sie odpali
  }
end

-- tu sie zaczyna zabawa
function BehaviorTree:run()
  if self.running then
    return
  else
    self.running = true
    self.rootNode = Registry.getNodeFromTree(self.treeState)
    self.rootNode:setParent(self)

    self.rootNode:start(self.treeState.payload)
    self.rootNode:run(self.treeState.payload)
  end
end

-- TODO refactor?
function BehaviorTree:restart()
    self:fail()
    self.treeState:setRunningNodeIndex(1)
    self.running = true
    self.rootNode:setParent(self)

    self.rootNode:start(self.treeState.payload)
    self.rootNode:run(self.treeState.payload)
end

function BehaviorTree:success()
  self.rootNode:finish(self.treeState.payload)
  self.running = false
end

function BehaviorTree:fail()
  self.rootNode:finish(self.treeState.payload)
  self.running = false
end

return BehaviorTree
