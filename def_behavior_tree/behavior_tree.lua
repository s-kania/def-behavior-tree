local class         = require "def_behavior_tree.middleclass"
local Registry      = require "def_behavior_tree.registry"
local Node          = require "def_behavior_tree.node_types.node"
local BehaviorTree = class("BehaviorTree")
 
BehaviorTree.Node                    = Node
BehaviorTree.Registry                = Registry
BehaviorTree.Task                    = Node
BehaviorTree.Composite               = require "def_behavior_tree.node_types.composite"
BehaviorTree.Priority                = "dupa"
BehaviorTree.ActivePriority          = "dupa"
BehaviorTree.Random                  = "dupa"
BehaviorTree.Sequence                = require "def_behavior_tree.node_types.sequence"
BehaviorTree.Decorator               = require "def_behavior_tree.node_types.decorator"
BehaviorTree.InvertDecorator         = require "def_behavior_tree.node_types.invert_decorator"
BehaviorTree.AlwaysFailDecorator     = "dupa"
BehaviorTree.AlwaysSucceedDecorator  = "dupa"
BehaviorTree.RepeatUntilFailDecorator= require "def_behavior_tree.node_types.repeat_until_fail_decorator"
-- BehaviorTree.Composite               = require "def_behavior_tree.node_types.composite"
-- BehaviorTree.Priority                = require "def_behavior_tree.node_types.priority"
-- BehaviorTree.ActivePriority          = require "def_behavior_tree.node_types.active_priority"
-- BehaviorTree.Random                  = require "def_behavior_tree.node_types.random"
-- BehaviorTree.Sequence                = require "def_behavior_tree.node_types.sequence"
-- BehaviorTree.Decorator               = require "def_behavior_tree.node_types.decorator"
-- BehaviorTree.InvertDecorator         = require "def_behavior_tree.node_types.invert_decorator"
-- BehaviorTree.AlwaysFailDecorator     = require "def_behavior_tree.node_types.always_fail_decorator"
-- BehaviorTree.AlwaysSucceedDecorator  = require "def_behavior_tree.node_types.always_succeed_decorator"
-- BehaviorTree.RepeatUntilFailDecorator= require "def_behavior_tree.node_types.repeat_until_fail_decorator"

BehaviorTree.registerTemplates = Registry.registerTemplates
BehaviorTree.getTreeTemplate = Registry.getTreeTemplate

BehaviorTree.version = "1.0.0"

function table.indexOf(t, object)
  if type(t) ~= "table" then error("table expected, got " .. type(t), 2) end

  for i, v in pairs(t) do
      if object == v then
          return i
      end
  end
end

function BehaviorTree:initialize(config)
  self.tree_state = {
    name = config.treeName,
    payload = config.payload,
    runningNode = nil,
    setRunningNode = function(self, node)
      self.runningNode = node
    end,
    -- TODO callback, jedno drzewo moze miec tylko jednego callbacka aktualnego
    -- ale statek moze plynac a drzewo robic inna akcje, np atakowac, wtedy callback plyniecia sie odpali
    -- nodes = {
    --   _tree = self --rootNode parent_id is _tree, set in registry
    -- },
    getNode = function(self, nodeID)
        return Registry.getNodeFromTree(nodeID, self.name)
    end,
    success = function(self)
        self.runningNode.success(self)
    end,
    fail = function(self)
        self.runningNode.fail(self)
    end,
  }
end

function BehaviorTree:run()
  if self.running then
    return
  else
    self.running = true
    self.rootNode = self.tree_state:getNode(1)

    self.tree_state:setRunningNode(self.rootNode)
    self.rootNode.start(self.tree_state)
    self.rootNode.run(self.tree_state)
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

function BehaviorTree:success()
  self.rootNode.finish(self.tree_state)
  self.running = false
end

function BehaviorTree:fail()
  self.rootNode.finish(self.tree_state)
  self.running = false
end

-- function BehaviorTree:goTo(nodeID)
--   local node = self.tree_state:getNode(nodeID)
-- end

return BehaviorTree
