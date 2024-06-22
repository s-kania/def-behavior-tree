local registeredTrees = {}

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
    Registry.addNodeTemplateToTree(registeredTrees[tree_name], data.main_node, getNodeTemplate, nil)
  end
end

function Registry.addNodeTemplateToTree(tree, template_data, getNodeTemplate, parent_id)
  local template, template_name = getNodeTemplate(template_data)

  local tree_template = {
    name = template_name,
    type = template.type,
    parent_id = parent_id,
    start = template.start,
    finish = template.finish,
    run = template.run,
  }

  --insert tree_template to get parent id for childs
  table.insert(tree, tree_template)
  local node_index = #tree

  if template.nodes then --sequences
    tree_template.nodes_id_list = {}

    for _, template_data in ipairs(template.nodes) do
      local child_index = Registry.addNodeTemplateToTree(tree, template_data, getNodeTemplate, node_index)
      table.insert(tree_template.nodes_id_list, child_index)
    end
  elseif template.node then --decorators
    tree_template.node_id = Registry.addNodeTemplateToTree(tree, template.node, getNodeTemplate, node_index)
  end

  return node_index
end

function Registry.getNodeFromTree(id, treeState)
  local treeTemplate = registeredTrees[treeState.name][id]

  return treeTemplate.type:new({
    id = id,
    parent_id = treeTemplate.parent_id or "_tree",
    _startTask = treeTemplate.start,
    _runTask = treeTemplate.run,
    _finishTask = treeTemplate.finish,
    nodes_id_list = treeTemplate.nodes_id_list,
    node_id = treeTemplate.node_id,
    chances = treeTemplate.chances, -- for random node
    treeState = treeState,
  })
end

function Registry.getTreeTemplate(treeName)
  return registeredTrees[treeName]
end

return Registry
