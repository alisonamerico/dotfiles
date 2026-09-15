-- ========================================

-- util para normalizar títulos em slugs
local function slugify(str)
  local replacements = {
    ["á"] = "a",
    ["à"] = "a",
    ["ã"] = "a",
    ["â"] = "a",
    ["ä"] = "a",
    ["Á"] = "A",
    ["À"] = "A",
    ["Ã"] = "A",
    ["Â"] = "A",
    ["Ä"] = "A",
    ["é"] = "e",
    ["è"] = "e",
    ["ê"] = "e",
    ["ë"] = "e",
    ["É"] = "E",
    ["È"] = "E",
    ["Ê"] = "E",
    ["Ë"] = "E",
    ["í"] = "i",
    ["ì"] = "i",
    ["î"] = "i",
    ["ï"] = "i",
    ["Í"] = "I",
    ["Ì"] = "I",
    ["Î"] = "I",
    ["Ï"] = "I",
    ["ó"] = "o",
    ["ò"] = "o",
    ["õ"] = "o",
    ["ô"] = "o",
    ["ö"] = "o",
    ["Ó"] = "O",
    ["Ò"] = "O",
    ["Õ"] = "O",
    ["Ô"] = "O",
    ["Ö"] = "O",
    ["ú"] = "u",
    ["ù"] = "u",
    ["û"] = "u",
    ["ü"] = "u",
    ["Ú"] = "U",
    ["Ù"] = "U",
    ["Û"] = "U",
    ["Ü"] = "U",
    ["ç"] = "c",
    ["Ç"] = "C",
    ["ñ"] = "n",
    ["Ñ"] = "N",
  }
  -- substitui acentos
  str = str:gsub("[%z\1-\127\194-\244][\128-\191]*", replacements)
  -- troca espaço por hífen e remove caracteres inválidos
  str = str:gsub(" ", "-"):gsub("[^A-Za-z0-9%-]", "")
  -- colapsa múltiplos hífens
  str = str:gsub("%-+", "-"):gsub("^%-", ""):gsub("%-$", "")
  return str:lower()
end

require("obsidian").setup({
  workspaces = {
    {
      name = "brain",
      path = "$HOME/obsidian-notes/brain",
    },
  },

  use_titles = false,
  notes_subdir = "Notes",
  new_notes_location = "notes_subdir",

  link = {
    style = "wiki",
  },

  note_id_func = function(title)
    local id = os.date("%Y%m%d%H%M")
    if title ~= nil then
      return id .. "-" .. slugify(title)
    else
      return id
    end
  end,

  frontmatter = {
    func = function(note)
      local title = note.title or note.id
      return {
        id = note.id,
        title = title,
        aliases = { title },
        created = os.date("%Y-%m-%d %H:%M"),
        tags = note.tags,
      }
    end,
  },

  templates = { folder = "_templates" },
  attachments = { folder = "_extras" },
  -- completion is now provided by the built-in obsidian-ls LSP server,
  -- so no nvim-cmp integration is configured here anymore.
  legacy_commands = false,
  ui = {
    enable = true,
    floor_dir = "~/.cache/obsidian.nvim/floor",
  },
  picker = { name = "telescope.nvim" },

  daily_notes = {
    folder = "Journal",
    template = "Daily Note.md",
    date_format = "%Y/%m/%Y-%m-%d %a",
  },

  -- wiki_link_func removed: link.style = "wiki" above already produces the
  -- same [[id|label]] format this custom function implemented.

  markdown_proc_func = function(ctx)
    return require("obsidian").markdown_proc(ctx, function(s)
      return s:gsub("{{date}}", function()
        return os.date("%Y-%m-%d")
      end)
    end)
  end,

  -- follow_url_func removed: obsidian.nvim now opens urls/attachments via
  -- Neovim's native vim.ui.open by default, so no override is needed.
})
