local registeredNodes = {}
local registeredTrees = {}

local Registry = {}

function Registry.addNodeDataToTree(tree, node_name, parent)
  local node = Registry.getNode(node_name)

  local nodeData = {
    parent = parent,
    class = node.class.name,
    name = type(node_name) == "string" and node_name,
  }

  table.insert(tree, nodeData)
  local node_index = #tree

  if node.nodes then
    nodeData.childs = {}
    for _, node_name in ipairs(node.nodes) do
      local child_index = Registry.addNodeDataToTree(tree, node_name, node_index)
      table.insert(nodeData.childs, child_index)
    end
  elseif node.node then
    nodeData.child = Registry.addNodeDataToTree(tree, node.node, node_index)
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
