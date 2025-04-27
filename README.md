# floatingtodo.nvim

a globally accessible buffer for managing tasks.

## Install

```lua
return {
  "vimichael/floatingtodo.nvim",
  config = function()
    require("floatingtodo").setup({
      target_file = "~/notes/todo.md",
      border = "single" -- single, rounded, etc.
    })
  end
}
```
