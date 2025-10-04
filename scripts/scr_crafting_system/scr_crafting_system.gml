/// Crafting System - Recipe Tree

// ===== RECIPE NODE CONSTRUCTOR =====
function RecipeNode(_name, _ingredients, _tier, _description) constructor {
    name = _name;
    ingredients = _ingredients;  // Array of ingredient names
    tier = _tier;
    description = _description;
    children = [];   // Recipes this unlocks
    parents = [];    // Required recipes (ingredients that are crafted)
    discovered = false;

    // Add child recipe (this unlocks child)
    static add_child = function(_child_node) {
        array_push(children, _child_node);
        array_push(_child_node.parents, self);
    }

    // Check if can be crafted (all parent ingredients discovered)
    static can_craft = function() {
        // Basic elements are always available
        if (tier == 0) return true;

        for (var i = 0; i < array_length(parents); i++) {
            if (!parents[i].discovered) return false;
        }
        return true;
    }

    // Get all descendants (entire branch below this recipe)
    static get_branch = function() {
        var branch = [self];
        for (var i = 0; i < array_length(children); i++) {
            var child_branch = children[i].get_branch();
            branch = array_concat(branch, child_branch);
        }
        return branch;
    }

    // Check if ingredients match (order independent)
    static matches_ingredients = function(_ing1, _ing2) {
        if (array_length(ingredients) != 2) return false;

        return (ingredients[0] == _ing1 && ingredients[1] == _ing2) ||
               (ingredients[0] == _ing2 && ingredients[1] == _ing1);
    }
}

// ===== LOAD RECIPES FROM JSON =====
function load_recipes_from_json(_filename) {
    var filepath = _filename;

    // Check if file exists
    if (!file_exists(filepath)) {
        show_debug_message("ERROR: Recipe file not found: " + filepath);
        return undefined;
    }

    // Read JSON file
    var file = file_text_open_read(filepath);
    var json_string = "";

    while (!file_text_eof(file)) {
        json_string += file_text_read_string(file);
        file_text_readln(file);
    }
    file_text_close(file);

    // Parse JSON
    var json_data = json_parse(json_string);
    return json_data;
}

// ===== BUILD RECIPE TREE FROM JSON =====
function build_recipe_tree_from_json(_json_data) {
    var nodes = {};
    var basic_elements = _json_data.elements.basic;

    // Create basic element nodes (tier 0)
    for (var i = 0; i < array_length(basic_elements); i++) {
        var elem = basic_elements[i];
        nodes[$ elem] = new RecipeNode(elem, [], 0, "Basic element");
        nodes[$ elem].discovered = true;  // Basic elements start discovered
    }

    // Create all recipe nodes
    for (var i = 0; i < array_length(_json_data.recipes); i++) {
        var recipe = _json_data.recipes[i];
        nodes[$ recipe.id] = new RecipeNode(
            recipe.result,
            recipe.ingredients,
            recipe.tier,
            recipe.description
        );
    }

    // Connect parent-child relationships based on unlocks
    for (var i = 0; i < array_length(_json_data.recipes); i++) {
        var recipe = _json_data.recipes[i];
        var node = nodes[$ recipe.id];

        if (variable_struct_exists(recipe, "unlocks")) {
            for (var j = 0; j < array_length(recipe.unlocks); j++) {
                var child_id = recipe.unlocks[j];
                if (variable_struct_exists(nodes, child_id)) {
                    node.add_child(nodes[$ child_id]);
                }
            }
        }
    }

    return nodes;
}

// ===== FIND RECIPE BY INGREDIENTS =====
function find_recipe_by_ingredients(_nodes, _ing1, _ing2) {
    var keys = variable_struct_get_names(_nodes);

    for (var i = 0; i < array_length(keys); i++) {
        var node = _nodes[$ keys[i]];
        if (node.matches_ingredients(_ing1, _ing2)) {
            return node;
        }
    }

    return noone;
}

// ===== GET RECIPES BY TIER =====
function get_recipes_by_tier(_nodes, _tier) {
    var result = [];
    var keys = variable_struct_get_names(_nodes);

    for (var i = 0; i < array_length(keys); i++) {
        var node = _nodes[$ keys[i]];
        if (node.tier == _tier) {
            array_push(result, node);
        }
    }

    return result;
}

// ===== GET ALL DISCOVERED RECIPES =====
function get_discovered_recipes(_nodes) {
    var result = [];
    var keys = variable_struct_get_names(_nodes);

    for (var i = 0; i < array_length(keys); i++) {
        var node = _nodes[$ keys[i]];
        if (node.discovered) {
            array_push(result, node);
        }
    }

    return result;
}
