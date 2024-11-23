# nvim.scratchpad

This is a simple implementation of a Neovim plugin that creates an empty buffer on load. It was based on Miguel Crespo's [blogpost](https://miguelcrespo.co/posts/how-to-write-a-neovim-plugin-in-lua) and this repository mainly serves as a basis for future inspiration/reminder for myself.

## Installation (lazy.nvim)

Add a new lua file to your `lazy.nvim` plugins directory with these contents:

```lua
return {
    'kersanszki-levente/nvim.scratchpad', # or replace it with a path to a local directory
    name = 'nvim.scratchpad',
    cmd = 'Scratchpad',
    config = function()
        require('scratch-buffer').setup()
    end
```
