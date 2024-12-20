# nvim.scratchpad.rs (WIP)

This is a simple implementation of a Neovim plugin for a Rust scratchpad. Upon invokation of the `Scratchpad` command, the plugin creates the `tmp/nvim.scratchpad.rs` directory and a new temporary-ish buffer. Writing to this buffer invokes rustc, which in turn compiles the contents of the buffer and then another command attempts to run the compiled code while returning stdout and stderr from both processes.

This plugin was inspired by Miguel Crespo's blogpost on [How to write a Neovim plugin in Lua](https://miguelcrespo.co/posts/how-to-write-a-neovim-plugin-in-lua).

## Installation (lazy.nvim)

Add a new lua file to your `lazy.nvim` plugins directory with these contents:

```lua
return {
    'kersanszki-levente/nvim.scratchpad.rs', -- or replace it with a path to a local directory
    name = 'nvim.scratchpad',
    cmd = 'Scratchpad',
    config = function()
        require('scratch-buffer').setup()
    end
}
```
