# Overview

The def-behavior tree is a library for creating behavioral trees that allow you to easily manage advanced NPC behaviors in your game.
It's functional and event-driven, which means that the next nodes are activated only when the previous one returns success or false.
It also have ability to run any node from any moment, which means, you can easily save active node ID and run it when game load for example.

If you are interested in how these trees work, be sure to read this article -> [Behavior trees for AI: How they work (gamedeveloper.com)](https://www.gamedeveloper.com/programming/behavior-trees-for-ai-how-they-work)
I was inspired by it and used some nodes descriptions in this Readme.

This library is based on [this](https://github.com/tanema/behaviourtree.lua) implementation by tanema, but heavily modified.

### Video showing example (click on image)
[![Example for def-behavior-tree library.](https://img.youtube.com/vi/1xFsJQuCiq4/0.jpg)](https://www.youtube.com/watch?v=1xFsJQuCiq4)

Video shows Roids example, but instead of player input, there is AI with behavior tree from this library.
There is also debug window showing traversal on nodes and their status.

# Installation

You can use the modules from this project in your own project by adding this project as a Defold library dependency. Open your game.project file and in the dependencies field under project add:

https://github.com/s-kania/def-behavior-tree/archive/master.zip
Or point to the ZIP file of a specific release.

Import library snippet:

```lua
local BehaviourTree = require "def_behavior_tree.behavior_tree"
```

# Nodes

A behaviour tree is made up of several types of nodes, however some core functionality is common to any type of node in a behaviour tree. This is that they can return one of two statuses, success or fail. As their names suggest, they inform their parent that their operation was a success or a failure.

There are 3 archetypes and its nodes

* Composite
  * Sequence
  * Selector
  * Random
  * RandomWithChances
* Decorator
  * AlwaysFailDecorator
  * AlwaysSucceedDecorator
  * ChanceDecorator
  * InvertDecorator
  * RepeatUntilFailDecorator
* Task (basic node)

Before you create behavior tree, you need to create nodes templates and registry them.
Create table with structure like this:

```lua
local bt_templates = {
    TREES = {
        BEHAVIOR_TREE_NAME = { --tree name
            main_node = "NODE_NAME"
        },
    },
    NODES = { -- there go all nodes which you want to use
        "NODE_NAME" = {
            type = BehaviorTree.Task,
            start = ,
            run = ,
            finish = ,
        },
    },
}
```

Templates should be registered once and before any behavior tree creation.

```lua
BehaviourTree.registerTemplates(bt_templates)
```

## Task

Task is lowest level node type, and is incapable of having any children nodes. Inside you can implement your behavior code.
`start` is fired before `run`, and `finish` is fired after task failure or succes.
`start` and `finish` functions are optional for `Task`.

All these functions have two arguments passed:

- `task` have two functions, `success` and `fail`, use them if you want finish your task. But you don't have to use them in `start `or `finish`, behavior tree don't expect these functions to return anything, but you can finish your task earlier if you want.
- `payload` is table which you will pass into tree, player data or anything you want

```lua
"IS_ALIVE" = { --example task name
    type = BehaviorTree.Task, --define type of node
    start = function (task, payload)
        --[...]
    end,
    run = function (task, payload) --payload is your passed game data, it may player for example
        if payload.health > 0 then
            return task:success()
        end
        task:fail()
    end,
    finish = function (task, payload)
        --[...]
    end,
},
```

## Composites

A composite node is a node that have list of nodes. They will process one or more of these children in either a first to last sequence or random order depending on the particular composite node in question, and at some stage will consider their processing complete and pass either success or failure to their parent, often determined by the success or failure of the child nodes.
All of composite nodes have `nodes` table, you can create another nodes inside, or reference by name to already existing nodes.

```lua
nodes = {
    "IS_ALIVE", -- behavior tree will search for node with this name in registry
    "WALK_TO_PLAYER",
    {
        -- you can also create anonymous nodes in another nodes, this is fine and usefull for creating nested behaviours
        type = BehaviorTree.Task,
        run = function (task, payload)
            -- do nasty things to a player here
        end,
    }
}
```

### Sequence

A sequence will visit each child in order, starting with the first, and when that succeeds will call the second, and so on down the list of children. If any child fails it will immediately return failure to the parent. If the last child in the sequence succeeds, then the sequence will return success to its parent.

```lua
{
    type = BehaviorTree.Sequence, -- define type of node
    nodes = {
        "NODE_NAME",
        {
            -- you can nest nodes inside of other nodes
            type = BehaviorTree.Sequence,
            nodes = {
                "NESTED_NODE",
                {
                    type = BehaviorTree.Task,
                    run = function (task, payload)
                        --[...]
                    end,
                },
            },
        },
    },
},
```

### Selector

Selector will return a success if any of its children succeed and not process any further children. It will process the first child, and if it fails will process the second, and if that fails will process the third, until a success is reached, at which point it will instantly return success. It will fail if all children fail.

```lua
{
    type = BehaviorTree.Selector,
    nodes = {
        "NODE_NAME",
        "ANOTHER_NODE_NAME",
    },
},
```

### Random

This node select random node from `nodes` list. By default, function which get random numbers is `math.random`, but you can pass your own rnd generator to tree. How to do this is explained later.

```lua
{
  type = BehaviorTree.Random,
  nodes = {
        "NODE_NAME",
        "ANOTHER_NODE_NAME",
    },
},
```

### RandomWithChances

This node is similiar to `Random`, but each node has a chance parameter that determines the chance of it being drawn. You can simply add a chance parameter to an existing node, or if you want to refer to an already registered node, use the chance decorator.
By default, the draw function selects numbers from 1 to 100, so your chances should accumulate to that number. However, it is possible to use your number generator and change the number range. How to do this is explained later.

```lua
{
    type = BehaviorTree.RandomWithChances,
    nodes = {
        {
            type = BehaviorTree.ChanceDecorator,
            chance = 30, -- chances from all nodes should accumulate to 100
            node = "IS_ALIVE", -- refer to another node
        },
        {
            type = BehaviorTree.ChanceDecorator,
            chance = 60,
            node = "STEAL_SOMETHING",
        },
        {
            type = BehaviorTree.Sequence,
            chance = 10,
            nodes = {
                -- your nodes list
            },
        },
    },
},
```

## Decorators

A decorator node can have a child node. Unlike a composite node, they can specifically only have a single child. Their function is either to transform the result they receive from their child node's status, to terminate the child, or repeat processing of the child, depending on the type of decorator node.

### AlwaysFailDecorator

As name suggest, no matter what child returns, the result will always be the fail.

```lua
{
    type = BehaviorTree.AlwaysFailDecorator,
    node = {
        "ANOTHER_NODE_NAME",
    },
},
```

### AlwaysSucceedDecorator

As name suggest, no matter what child returns, the result will always be the success.

```lua
{
    type = BehaviorTree.AlwaysSucceedDecorator,
    node = {
        "ANOTHER_NODE_NAME",
    },
},
```

### ChanceDecorator

This node is only used together with the `RandomWithChances` composite. If you want to use the names of other nodes in the list in `RandomWithChances`, this decorator will dress your node accordingly and add a chance parameter.

```lua
{
    type = BehaviorTree.ChanceDecorator,
    chance = 30,
    node = {
        "NODE_NAME",
    },
},
```

### InvertDecorator

Revert child returned status. So if the node returns success, the decorator turns it to fail and vice versa.

```lua
{
    type = BehaviorTree.InvertDecorator,
    node = {
        "NODE_NAME",
    },
},
```

### RepeatUntilFailDecorator

Repeat it's child until it return fail status. Good for Behavior tree root node.

```lua
{
    type = BehaviorTree.RepeatUntilFailDecorator,
    node = {
        "NODE_NAME",
    },
},
```

# Usage

### New tree

Once the templates have been registered, as explained at the beginning, you can start creating trees.

```lua
local ship = {} -- example game player data, it can be anything you want, later it will be passed to your task nodes

local bt_tree = BehaviourTree.new({
    tree_name = "BEHAVIOR_TREE_NAME", -- select tree registered under your templates.TREES table
    payload = ship, -- payload is object on which tree will operate
    rng = function (range_start, range_end) -- this is optional, you can pass your random number generator function, which will be used with Random and RandomWithChances composites. If you don't, math.random is used by default
        return rng.range(range_start, range_end) -- rng.range is example random number generator function,
    end,
})

bt_tree:run()
```

### Active node

You can get active node ID, and use it later. For example when loading game, and you want to start your NPC behaviour right when user saved game.
Node ID is not the same as node name in templates. Once the templates are registered, each tree has its own list of nodes and each node has a unique id, even if they refer to the same node from the template. This way, you do not have to worry about using the same node multiple times in a composed tree.

```lua
local active_node_id = bt_tree.activeNode.id

-- later when, for example you will load your game, you can run tree like this
bt_tree:run(active_node_id)

-- you can also restart tree
bt_tree:restart()
-- or
bt_tree:restart(node_id)
```

### Tree template

If you want to know nodes id's, you can get registered tree template:

```lua
local tree_template = BehaviourTree.getTreeTemplate("BT_NAME")
```

### Running

You can check if your tree is running:

```lua
local is_running = bt_tree.running
```

# Inside of behavior tree

Let's go into the jungle of implemenation.
`def_behavior_tree` structure:

- behavior_tree.lua - class for managing created behavior tree state
- registry.lua - module for storing registered trees and nodes
- nodes_types - folder with different nodes and archetypes

### Registry

This module stores registered trees templates. Tree template is table created by registry module for each tree defined by user in its templates under `TREES. User template is created by you, like in examples above. Each tree template has its own unique list of nodes with a unique ID for each. In turn, each node in such a tree has references to functions from user-created templates and its parent and possibly children.
Why in this way? In templates you can use the nodes you have created as many times as you want. They can nest, so if you want to be able to jump to any node in the tree, each node in the tree must have a unique ID.
For example, we have the node `IS_ALIVE`. It is used several times in the tree in different places. When registering templates, each reference to this node will generate a unique ID and an object to hold the reference to the function from the template created by the user, as well as the unique parent.

Registered tree template will look something like this:

```lua
SOME_BT_TREE_REGISTRY_TEMPLATE = {
    1 = {
        id = 1,
        name = "IS_ALIVE",
        parent = -- parent tree template reference,
        type = BehaviorTree.Task,
        run = -- reference to user template function for "IS_ALIVE" node,
    },
    2 = --another node table,
    3 = --another node table,
    4 = {
        -- second appearance of the node ‘IS_ALIVE’
        id = 4, -- different ID
        name = "IS_ALIVE",
        parent = -- different parent
        type = BehaviorTree.Task,
        run = -- same reference to user template function,
    },
}
```

You can check how it looks like with this snippet mentioned earlier:
```lua
local tree_template = BehaviourTree.getTreeTemplate("BT_NAME")
```

### BehaviorTree object
Simply put, created BT object stores references to the active node from the tree template. It then fires functions from the references to the node type.

# Example
In the video from beggining, you can see that debug window. I took oficial Roids example and changed player steering to behavior tree.
Debug window uses imggui library.
You are interested in two files:
- `bt_templates.lua` -> example bt templates and use different types of nodes
- `debug_window.script` -> this is simply written to see how the tree works visually, but the code itself is not the best, so I suggest you rework it to suit your needs if you gonna need it

# Finally
I encourage you to look at the code, it's not a lot and I've tried to add comments to make it easier to understand what's going on there.
If you see something that could be done better, feel free to create an Issue or Pull request from your fork.

Ohh, and if you use this library in your game you release, let me know if you want to and I'll be happy to put that information here :)
