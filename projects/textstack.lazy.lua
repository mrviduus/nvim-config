-- Project-local LazyVim tweaks for textstack. Not committed (.git/info/exclude).

-- Frontend isn't prettier-formatted: format-on-save would rewrite whole files.
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact", "json", "jsonc", "css", "scss", "html", "markdown", "yaml" },
  callback = function() vim.b.autoformat = false end,
})

return {
  -- CI gates C# on `dotnet format`; csharpier would fight it.
  -- Empty list -> conform falls back to OmniSharp (Roslyn, same engine).
  { "stevearc/conform.nvim", opts = { formatters_by_ft = { cs = {} } } },
}
