local registeredNodes = {}
local registeredTrees = {}

local Registry = {}

--[[
  registeredNodes -> nodes created by user
  registeredTrees -> node tree with parent-child relation based on index
  thanks to this we can traverse on tree, save, load
]]
function Registry.registerTemplates(templates)
  -- nodes
  registeredNodes = templates.NODES

  -- trees
  for tree_name, data in pairs(templates.TREES) do
    registeredTrees[tree_name] = {}
    Registry.addNodeTemplateToTree(registeredTrees[tree_name], data.main_node)
  end
end

function Registry.addNodeTemplateToTree(tree, template, parent_id)
  local template, template_name = Registry.getNodeTemplate(template)

  local tree_template = {
    name = template_name or template.type.name,
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
      local child_index = Registry.addNodeTemplateToTree(tree, template_data, node_index)
      table.insert(tree_template.nodes_id_list, child_index)
    end
  elseif template.node then --decorators
    tree_template.node_id = Registry.addNodeTemplateToTree(tree, template.node, node_index)
  end

  return node_index
end

function Registry.getNodeTemplate(template)
  if type(template) == "string" then --registered task or sequence
    return registeredNodes[template], template
  end
  return template --pure node in registeredNodes
end

function Registry.getNodeFromTree(treeState)
  local treeTemplate = registeredTrees[treeState.name][treeState.runningNodeIndex]

  return treeTemplate.type:new({
    _index = treeState.runningNodeIndex,
    parent_id = treeTemplate.parent_id,
    start = treeTemplate.start,
    finish = treeTemplate.finish,
    run = treeTemplate.run,
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
