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
  -- przniesc ustawianie obiektu tutaj
end

-- tu sie zaczyna zabawa
function BehaviorTree:run(object)
  if self.running then -- to na początek będzie false, ale jesli sprobojemy drugi raz odpalic drzewo, nie wiem co zrobi
    return --call running if we have control
  else
    self.running = true
    self.object = object or self.object -- obiekt np ship
    self.rootNode = Registry.getNode(self.tree) -- pierwszy node z drzewa, w przypadku simple sailor jest to repeat_until_fail
    self.rootNode:setParentNode(self) -- ustawia kontrole, ja bym nazwal to parentNode
    self.rootNode:start(self.object) -- odpala inicjalizator taska, w moim przypadku nic
    self.rootNode:run(self.object) -- to jest pojebane bo ustawia te dziwne globalne sukcesy z NODE, ktore moga się plątać z innymi
  end
end

function BehaviorTree:restart()
    self:fail()
    self.running = true
    self.rootNode:setParentNode(self)
    self.rootNode:start(self.object)
    self.rootNode:run(self.object)
end

function BehaviorTree:success()
  self.rootNode:finish(self.object)
  self.running = false
end

function BehaviorTree:fail()
  self.rootNode:finish(self.object)
  self.running = false
end

return BehaviorTree
