document.addEventListener('DOMContentLoaded', () => {
    // --- DOM Elements ---
    const addSequenceBtn = document.getElementById('add-sequence');
    const addSelectorBtn = document.getElementById('add-selector');
    const addTaskBtn = document.getElementById('add-task');
    const treeVisualContainer = document.getElementById('tree-visual');
    const propertiesPanel = document.getElementById('properties-panel');
    const exportBtn = document.getElementById('export-lua');
    const luaOutput = document.getElementById('lua-output');

    // --- State ---
    let nodeIdCounter = 0;
    let selectedNode = null;

    // The root of our behavior tree
    let tree = {
        id: nodeIdCounter++,
        type: 'Sequence', // Root is often a sequence or selector
        name: 'ROOT_SEQUENCE',
        children: []
    };

    // --- Functions ---

    /**
     * Creates a new node object.
     * @param {string} type - The type of the node (e.g., 'Sequence', 'Selector', 'Task').
     * @returns {object} The new node.
     */
    function createNode(type) {
        const nodeId = nodeIdCounter++;
        let node = {
            id: nodeId,
            type: type,
            name: `${type.toUpperCase()}_${nodeId}`,
        };
        if (type === 'Sequence' || type === 'Selector') {
            node.children = [];
        }
        return node;
    }

    /**
     * Recursively renders the tree structure into the DOM.
     * @param {object} node - The current node to render.
     * @param {HTMLElement} parentElement - The DOM element to append the node to.
     */
    function renderTree(node, parentElement) {
        const nodeElement = document.createElement('div');
        nodeElement.classList.add('node');
        nodeElement.dataset.id = node.id;
        if (selectedNode && node.id === selectedNode.id) {
            nodeElement.classList.add('selected');
        }

        const nodeHeader = document.createElement('div');
        nodeHeader.classList.add('node-header');

        const nodeName = document.createElement('span');
        nodeName.textContent = `${node.name} [${node.type}]`;
        nodeHeader.appendChild(nodeName);

        const deleteBtn = document.createElement('button');
        deleteBtn.textContent = 'x';
        deleteBtn.classList.add('delete-btn');
        deleteBtn.onclick = (e) => {
            e.stopPropagation(); // Prevent node selection when deleting
            deleteNode(node.id);
        };
        nodeHeader.appendChild(deleteBtn);

        nodeElement.appendChild(nodeHeader);

        // Click to select node
        nodeElement.onclick = () => {
            selectNode(node);
        };

        parentElement.appendChild(nodeElement);

        if (node.children) {
            const childrenContainer = document.createElement('div');
            childrenContainer.classList.add('children-container');
            nodeElement.appendChild(childrenContainer);
            node.children.forEach(child => renderTree(child, childrenContainer));
        }
    }

    /**
     * Clears and re-renders the entire tree display.
     */
    function redrawTree() {
        treeVisualContainer.innerHTML = '';
        renderTree(tree, treeVisualContainer);
    }

    /**
     * Finds a node by its ID in the tree.
     * @param {number} id - The ID of the node to find.
     * @param {object} node - The node to start searching from.
     * @returns {object|null} The found node or null.
     */
    function findNodeById(id, node = tree) {
        if (node.id === id) {
            return node;
        }
        if (node.children) {
            for (const child of node.children) {
                const found = findNodeById(id, child);
                if (found) {
                    return found;
                }
            }
        }
        return null;
    }

    /**
     * Finds the parent of a given node.
     * @param {number} id - The ID of the node whose parent to find.
     * @param {object} parentNode - The node to start searching from.
     * @returns {object|null} The parent node or null.
     */
    function findParentNode(id, parentNode = tree) {
        if (parentNode.children) {
            for (const child of parentNode.children) {
                if (child.id === id) {
                    return parentNode;
                }
                const foundParent = findParentNode(id, child);
                if (foundParent) {
                    return foundParent;
                }
            }
        }
        return null;
    }

    /**
     * Deletes a node from the tree.
     * @param {number} id - The ID of the node to delete.
     */
    function deleteNode(id) {
        if (id === tree.id) {
            alert("Cannot delete the root node.");
            return;
        }
        const parent = findParentNode(id);
        if (parent && parent.children) {
            parent.children = parent.children.filter(child => child.id !== id);
            if (selectedNode && selectedNode.id === id) {
                selectNode(null); // Deselect if deleted
            }
            redrawTree();
        }
    }

    /**
     * Sets the currently selected node and re-renders the UI.
     * @param {object|null} node - The node to select, or null to deselect.
     */
    function selectNode(node) {
        selectedNode = node;
        renderProperties();
        redrawTree();
    }

    /**
     * Renders the properties panel for the currently selected node.
     */
    function renderProperties() {
        if (!selectedNode) {
            propertiesPanel.innerHTML = '<p>Select a node to see its properties.</p>';
            return;
        }

        propertiesPanel.innerHTML = `
            <div>
                <label for="prop-name">Name:</label>
                <input type="text" id="prop-name" value="${selectedNode.name}">
            </div>
            <div>
                <strong>Type:</strong> ${selectedNode.type}
            </div>
            <div>
                <strong>ID:</strong> ${selectedNode.id}
            </div>
        `;

        if (selectedNode.type === 'Task') {
            propertiesPanel.innerHTML += `
                <div>
                    <label for="prop-run">run = function(task, payload)</label>
                    <textarea id="prop-run" rows="10" placeholder="-- Your Lua code here...">${selectedNode.run || ''}</textarea>
                </div>
            `;
        }

        // Add change listeners to update the tree data
        document.getElementById('prop-name').onchange = (e) => {
            selectedNode.name = e.target.value.trim().replace(/\s/g, '_').toUpperCase();
            redrawTree();
        };

        if (selectedNode.type === 'Task') {
            document.getElementById('prop-run').onchange = (e) => {
                selectedNode.run = e.target.value;
            };
        }
    }

    /**
     * Adds a new node to the selected node or the root.
     * @param {string} type - The type of node to add.
     */
    function addNode(type) {
        const newNode = createNode(type);
        let parent = selectedNode || tree;

        // Tasks cannot have children. Add to parent instead.
        if (parent.type === 'Task') {
            parent = findParentNode(parent.id) || tree;
        }

        parent.children.push(newNode);
        selectNode(newNode); // Select the new node
        redrawTree();
    }

    // --- Event Listeners ---
    addSequenceBtn.onclick = () => addNode('Sequence');
    addSelectorBtn.onclick = () => addNode('Selector');
    addTaskBtn.onclick = () => addNode('Task');

    // --- Initial Render ---
    selectNode(tree); // Select the root node initially
    redrawTree();

    // --- Export Logic ---

    /**
     * Recursively traverses the node and its children to build a flat list of nodes
     * for the NODES table.
     * @param {object} node - The starting node.
     * @param {Array<object>} nodeList - The list to accumulate nodes in.
     */
    function collectNodes(node, nodeList) {
        nodeList.push(node);
        if (node.children) {
            node.children.forEach(child => collectNodes(child, nodeList));
        }
    }

    /**
     * Converts a single JavaScript node object into its Lua string representation.
     * @param {object} node - The node to convert.
     * @returns {string} The Lua code for the node.
     */
    function convertNodeToLua(node) {
        let childrenRefs = '';
        if (node.children) {
            childrenRefs = node.children.map(child => `\n\t\t\t\t"${child.name}",`).join('');
        }

        let nodeStr = `\t["${node.name}"] = {\n`;
        nodeStr += `\t\ttype = BehaviourTree.${node.type},\n`;

        if (node.type === 'Task') {
            const runFunc = (node.run || '').replace(/\n/g, '\n\t\t\t');
            nodeStr += `\t\trun = function(task, payload)\n\t\t\t${runFunc}\n\t\tend,\n`;
        }

        if (node.children && node.children.length > 0) {
            nodeStr += `\t\tnodes = {${childrenRefs}\n\t\t\t},\n`;
        }

        nodeStr += `\t},`;
        return nodeStr;
    }

    /**
     * Generates the full Lua script from the behavior tree.
     */
    function exportToLua() {
        const allNodes = [];
        collectNodes(tree, allNodes);

        const nodesLua = allNodes.map(convertNodeToLua).join('\n');

        const treeName = "MY_BEHAVIOUR_TREE";
        const rootNodeName = tree.name;

        const luaScript =
`local BehaviourTree = require "def_behavior_tree.behavior_tree"

local M = {}

M.TREES = {
\t["${treeName}"] = {
\t\tmain_node = "${rootNodeName}"
\t},
}

M.NODES = {
${nodesLua}
}

return M`;

        luaOutput.value = luaScript;
    }

    exportBtn.onclick = exportToLua;
});