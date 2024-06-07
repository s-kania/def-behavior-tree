local registeredNodes = {}

local Registry = {}

function Registry.register(nodeTemplates)
  for name, template in pairs(nodeTemplates) do
    registeredNodes[name] = template;
  end
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
      node = Registry.getNode(template.node)
    })
  end
  
  if template.nodes then
    -- nodes powinny byc tworzone raczej na zadanie? albo przepisac z templatki
    -- przy wczytywaniu jesli np wczytywany node jest ostatni, pod nodes mozna go przypisac
    local nodes = {}
    for i, node in ipairs(template.nodes) do
      nodes[i] = Registry.getNode(node)
    end

    local config = {
      nodes = nodes
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
