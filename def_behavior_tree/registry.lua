local registeredTrees = {}
local empty_fn = function () end

local Registry = {}

--[[
  registeredTrees -> node tree with parent-child relation based on index
  thanks to this we can traverse on tree, save, load
]]
function Registry.registerTemplates(templates)
  -- return template and it's name
  local getNodeTemplate = function (template_data)
    if type(template_data) == "string" then --registered task or sequence
      local template = templates.NODES[template_data]
      local template_name = template.type.name == "Node" and template_data or template_data .. " | " .. template.type.name
      return template, template_name
    end
    return template_data, template_data.type.name --pure node in registeredNodes
  end

  -- register trees
  for tree_name, data in pairs(templates.TREES) do
    registeredTrees[tree_name] = {}
    local bt_end_node_fn = {
        success = function(tree)
            tree:success()
        end,
        fail = function(tree)
            tree:fail()
        end
    }
    Registry.addNodeTemplateToTree(registeredTrees[tree_name], data.main_node, getNodeTemplate, bt_end_node_fn)
  end
end

function Registry.addNodeTemplateToTree(tree, template_data, getNodeTemplate, parent)
  local template, template_name = getNodeTemplate(template_data)

  local tree_template = {
    id = nil,
    name = template_name,
    parent = parent,
    type = template.type,
    start = template.type.start or empty_fn,
    run = template.type.run or empty_fn,
    finish = template.type.finish or empty_fn,
    _start = template.start or empty_fn,
    _run = template.run or empty_fn,
    _finish = template.finish or empty_fn,
    success = template.type.success,
    fail = template.type.fail,
    chance = template.chance,
  }

  --insert tree_template to get parent id for childs
  table.insert(tree, tree_template)
  local nodeID = #tree
  tree_template.id = nodeID

  if template.nodes then --composites
    tree_template.nodes = {}

    for _, template_data in ipairs(template.nodes) do
      local child_node = Registry.addNodeTemplateToTree(tree, template_data, getNodeTemplate, tree_template)
      table.insert(tree_template.nodes, child_node)
    end
  elseif template.node then --decorators
    tree_template.node = Registry.addNodeTemplateToTree(tree, template.node, getNodeTemplate, tree_template)
  end

  return tree_template
end

function Registry.getNodeFromTree(id, treeName)
  return registeredTrees[treeName][id]
end

function Registry.getTreeTemplate(treeName)
  return registeredTrees[treeName]
end

return Registry

