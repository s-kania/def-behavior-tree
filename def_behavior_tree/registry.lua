local registeredNodes = {}
local registeredTrees = {}

local Registry = {}

function Registry.addNodeDataToTree(tree, node_name, parent_id)
  local node = Registry.getNode(node_name)

  local nodeData = {
    parent_id = parent_id,
    type = node.class,
    name = type(node_name) == "string" and node_name,
  }

  table.insert(tree, nodeData)
  local node_index = #tree

  if node.nodes then
    nodeData.child_id_list = {}
    for _, node_name in ipairs(node.nodes) do
      local child_index = Registry.addNodeDataToTree(tree, node_name, node_index)
      table.insert(nodeData.child_id_list, child_index)
    end
  elseif node.node then
    nodeData.child_id = Registry.addNodeDataToTree(tree, node.node, node_index)
  end

  return node_index
end

function Registry.registerTrees(treesData)
  local nodes = registeredNodes
  for tree_name, data in pairs(treesData) do
    registeredTrees[tree_name] = {}
    Registry.addNodeDataToTree(registeredTrees[tree_name], data.main_node)
  end

  print('registerTrees')
end

function Registry.registerNodes(nodeTemplates)
  for name, template in pairs(nodeTemplates) do
    registeredNodes[name] = template
  end

  print('registerNodes')
end

function Registry.getTreeNodes(tree_name)
  return registeredTrees[tree_name]
end

-- could be name of template, node template, or node object
function Registry.getNode(node)
  if type(node) == "string" then
    local template = registeredNodes[node]
    return Registry.createNodeFromTemplate(template)
  elseif node.type or node.decorator then
    return Registry.createNodeFromTemplate(node)
  else
    return node
  end
end

function Registry.getNodeFromTree(treeState)
  local treeTemplate = registeredTrees[treeState.name][treeState.runningNodeIndex]
  local node = Registry.createNodeFromTree(treeTemplate)
  node.treeState = treeState
  return node
end

function Registry.createNodeFromTree(treeTemplate)
  if treeTemplate.type.name == "Node" then
    return Registry.getNode(treeTemplate.name)
  end

  return treeTemplate.type:new({
    nodes_id_list = treeTemplate.child_id_list,
    node_id = treeTemplate.child_id,
  })
end

function Registry.createNodeFromTemplate(template)
  if template.decorator then
    return template.decorator:new({
      node = template.node
    })
  end
  
  if template.nodes then
    -- nodes powinny byc tworzone raczej na żądanie? albo przepisac z templatki
    -- przy wczytywaniu jesli np wczytywany node jest ostatni, pod nodes mozna go przypisac
    -- local nodes = {}
    -- for i, node in ipairs(template.nodes) do
    --   nodes[i] = Registry.getNode(node)
    -- end

    local config = {
      nodes = template.nodes
    }

    -- for Random type
    if template.chances then
      if not template.cumulativeChances then
        local cumulativeChances = {}
        
        for i = 1, #template.chances do
          cumulativeChances[i] = template.chances[i] + (cumulativeChances[i - 1] or 0)
        end

        template.cumulativeChances = cumulativeChances
      end

      config.cumulativeChances = template.cumulativeChances
    end
    
    return template.type:new(config)
  end

  return template.type:new({
    start = template.start,
    finish = template.finish,
    run = template.run,
  })
end

return Registry
