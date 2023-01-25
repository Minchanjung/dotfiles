-- auto install packer if not installed
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
    vim.cmd([[packadd packer.nvim]])
    return true
  end
  return false
end
local packer_bootstrap = ensure_packer() -- true if packer was just installed

-- autocommand that reloads neovim and installs/updates/removes plugins
-- when file is saved
vim.cmd([[ 
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins-setup.lua source <afile> | PackerSync
  augroup end
]])

local status, packer = pcall(require, "packer")
if not status then
  return
end

return packer.startup(function(use)
  use("wbthomason/packer.nvim")
  
  use("nvim-lua/plenary.nvim")
  
  use("morhetz/gruvbox") --current colorscheme
  use("kyazdani42/nvim-web-devicons")
  
  use("nvim-lualine/lualine.nvim")

  --autocompletion
  use("hrsh7th/nvim-cmp")
  use("hrsh7th/cmp-buffer")
  use("hrsh7th/cmp-path")
  
  --snippets
  use("L3MON4D3/LuaSnip")

    
  --fuzzy finder
  use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
  use({ "nvim-telescope/telescope.nvim", branch = "0.1.x" })


  --lsp servers
  use("williamboman/mason.nvim")
  use("williamboman/mason-lspconfig.nvim")
  use("neovim/nvim-lspconfig")
  use("hrsh7th/cmp-nvim-lsp")
  use({ "glepnir/lspsaga.nvim", branch = "main" })
  use("onsails/lspkind.nvim")

  use({
    "nvim-treesitter/nvim-treesitter", 
    run = function() 
      require("nvim-treesitter.install").update({ with_sync = true })
    end,
  })

  use("windwp/nvim-autopairs")
  use("windwp/nvim-ts-autotag")

  if packer_bootstrap then
    require("packer").sync()
  end
end)
