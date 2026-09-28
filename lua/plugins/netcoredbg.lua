-- C# debugging on Apple Silicon: Mason's netcoredbg is x86_64 and hangs on arm64 .NET.
-- This plugin ships a native arm64 build and registers the `coreclr` adapter + a launch config.
-- Other platforms keep LazyVim's Mason netcoredbg.
return {
  "Cliffback/netcoredbg-macOS-arm64.nvim",
  cond = jit.os == "OSX" and jit.arch == "arm64",
  dependencies = { "mfussenegger/nvim-dap" },
  ft = "cs",
  config = function()
    require("netcoredbg-macOS-arm64").setup()
  end,
}
