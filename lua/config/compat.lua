-- Compatibility shims for APIs that Neovim 0.10+ and the nvim-treesitter `main`
-- rewrite removed.
--
-- `Miloas/miloas.snippets` still targets the old APIs (`nvim-treesitter.ts_utils`,
-- `nvim-treesitter.locals`, `vim.treesitter.set_query`, ...). The real fix belongs
-- in that repo; this keeps it loading until then.

-- `vim.treesitter` aliases removed in Neovim 0.9/0.10
if not vim.treesitter.query.get_node_text then
  vim.treesitter.query.get_node_text = function(node, source, opts)
    return vim.treesitter.get_node_text(node, source, opts)
  end
end
if not vim.treesitter.get_query then
  vim.treesitter.get_query = vim.treesitter.query.get
end
if not vim.treesitter.set_query then
  vim.treesitter.set_query = vim.treesitter.query.set
end

-- Removed with the nvim-treesitter module system.
package.preload["nvim-treesitter.ts_utils"] = function()
  return {
    get_node_at_cursor = function(winnr)
      return vim.treesitter.get_node({ winid = winnr or 0 })
    end,
    get_node_text = function(node, source)
      return vim.split(vim.treesitter.get_node_text(node, source or 0), "\n")
    end,
  }
end

package.preload["nvim-treesitter.locals"] = function()
  return {
    -- The original walked `locals.scm` scopes; every caller here only needs the
    -- chain of enclosing nodes, innermost first.
    get_scope_tree = function(node, _)
      local scopes = {}
      local current = node
      while current do
        table.insert(scopes, current)
        current = current:parent()
      end
      return scopes
    end,
  }
end
