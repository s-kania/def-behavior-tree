-- local class         = require "def_behavior_tree.middleclass"
-- local Registry      = require "def_behavior_tree.registry"
-- local Node          = require "def_behavior_tree.node_types.node"
-- local BehaviorTree = class("BehaviorTree", Node)
 
-- BehaviorTree.Node                    = Node
-- BehaviorTree.Registry                = Registry
-- BehaviorTree.Task                    = Node
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

-- BehaviorTree.registerTemplates = Registry.registerTemplates
-- BehaviorTree.getTreeTemplate = Registry.getTreeTemplate

-- BehaviorTree.version = "1.0.0"

-- function table.indexOf(t, object)
--   if type(t) ~= "table" then error("table expected, got " .. type(t), 2) end

--   for i, v in pairs(t) do
--       if object == v then
--           return i
--       end
--   end
-- end

-- function BehaviorTree:initialize(config)
--   Node.initialize(self, config)
--   self.treeState = {
--     name = config.treeName,
--     payload = config.payload,
--     -- runningNodeID = config.runningNodeID or 1,
--     -- setRunningNodeID = function(self, index)
--     --   self.runningNodeID = index
--     -- end,
--     -- TODO callback, jedno drzewo moze miec tylko jednego callbacka aktualnego
--     -- ale statek moze plynac a drzewo robic inna akcje, np atakowac, wtedy callback plyniecia sie odpali
--     nodes = {
--       _tree = self --rootNode parent_id is _tree, set in registry
--     },
--     getNode = function(self, nodeID)
--       if self.nodes[nodeID] then
--         return self.nodes[nodeID]
--       end
--       local node = Registry.getNodeFromTree(nodeID, self)
--       self.nodes[nodeID] = node
--       return node
--     end
--   }
-- end

-- -- tu sie zaczyna zabawa
-- function BehaviorTree:run()
--   if self.running then
--     return
--   else
--     self.running = true
--     self.rootNode = self.treeState:getNode(1)

--     -- self.treeState:setRunningNodeID(1) -- TODO przeniesc do start/run/finish
--     self.rootNode:start()
--     self.rootNode:run()
--   end
-- end

-- -- TODO refactor?
-- function BehaviorTree:restart()
--     self:fail()
--     -- self.treeState:setRunningNodeID(1)
--     self.running = true

--     self.rootNode:start()
--     self.rootNode:run()
-- end

-- function BehaviorTree:success()
--   self.rootNode:finish()
--   self.running = false
-- end

-- function BehaviorTree:fail()
--   self.rootNode:finish()
--   self.running = false
-- end

-- function BehaviorTree:goTo(nodeID)
--   local node = self.treeState:getNode(nodeID)
-- end

-- return BehaviorTree
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
BehaviorTree.Decorator               = "dupa"
BehaviorTree.InvertDecorator         = "dupa"
BehaviorTree.AlwaysFailDecorator     = "dupa"
BehaviorTree.AlwaysSucceedDecorator  = "dupa"
BehaviorTree.RepeatUntilFailDecorator= "dupa"

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
  -- Node.initialize(self, config)
  self.treeState = {
    name = config.treeName,
    payload = config.payload,
    runningNodeID = config.runningNodeID or 1,
    setRunningNodeID = function(self, index)
      self.runningNodeID = index
    end,
    -- TODO callback, jedno drzewo moze miec tylko jednego callbacka aktualnego
    -- ale statek moze plynac a drzewo robic inna akcje, np atakowac, wtedy callback plyniecia sie odpali
    -- nodes = {
    --   _tree = self --rootNode parent_id is _tree, set in registry
    -- },
    getCurrentNode = function(self)
      return self:getNode(self.runningNodeID)
    end,
    getCurrentNodeParent = function(self)
      local currentNode = self:getCurrentNode()
      if currentNode.parent_id == nil then
        return print('dupsko')
      end
      return self:getNode(currentNode.parent_id)
    end,
    getNode = function(self, nodeID)
      return Registry.getNodeFromTree(nodeID, self.name)
    end,
    success = function(self)
      local node = self:getCurrentNode()
      node:success(self)
    end,
    fail = function(self)
      local node = self:getCurrentNode()
      node:fail(self)
    end,
  }
end

-- tu sie zaczyna zabawa
function BehaviorTree:run()
  if self.running then
    return
  else
    self.running = true
    self.rootNode = self.treeState:getNode(1)

    -- self.treeState:setRunningNodeID(1) -- TODO przeniesc do start/run/finish
    self.rootNode:start(self.treeState)
    self.rootNode:run(self.treeState)
  end
end

-- TODO refactor?
-- function BehaviorTree:restart()
--     self:fail()
--     -- self.treeState:setRunningNodeID(1)
--     self.running = true

--     self.rootNode:start()
--     self.rootNode:run()
-- end

function BehaviorTree:success()
  self.rootNode:finish(self.treeState)
  self.running = false
end

function BehaviorTree:fail()
  self.rootNode:finish(self.treeState)
  self.running = false
end

-- function BehaviorTree:goTo(nodeID)
--   local node = self.treeState:getNode(nodeID)
-- end

return BehaviorTree
