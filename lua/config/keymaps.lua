-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Visual Studio muscle memory
local map = vim.keymap.set
local dap = function(fn) return function() require("dap")[fn]() end end
map("n", "<F5>", dap("continue"), { desc = "Debug: start/continue" })
map("n", "<S-F5>", dap("terminate"), { desc = "Debug: stop" })
map("n", "<F9>", dap("toggle_breakpoint"), { desc = "Debug: toggle breakpoint" })
map("n", "<F10>", dap("step_over"), { desc = "Debug: step over" })
map("n", "<F11>", dap("step_into"), { desc = "Debug: step into" })
map("n", "<S-F11>", dap("step_out"), { desc = "Debug: step out" })
map("n", "<F12>", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "<S-F12>", vim.lsp.buf.references, { desc = "Find all references" })
map("n", "<F2>", vim.lsp.buf.rename, { desc = "Rename symbol" })
map({ "n", "v" }, "<C-.>", vim.lsp.buf.code_action, { desc = "Quick actions" })
map("n", "<C-p>", function() Snacks.picker.files() end, { desc = "Go to file" })
map("n", "<C-S-f>", function() Snacks.picker.grep() end, { desc = "Find in files" })
