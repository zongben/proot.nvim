# CHANGELOG

## 2025-06-16

**!BREAKING CHANGE!**

The persisted JSON file format has been restructured to support the new "rename project" feature.  

If you're upgrading from a previous version, please delete the file at:
`vim.fn.stdpath("state")/proot/proot.json`  

This will remove all previously stored project paths. After deletion, the plugin will work normally and begin storing new data using the updated format.
