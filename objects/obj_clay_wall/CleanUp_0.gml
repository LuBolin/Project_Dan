// Destroy the initially damaged enemies list
if (ds_exists(initially_damaged_enemies, ds_type_list)) {
    ds_list_destroy(initially_damaged_enemies);
}