-- vim: ts=4 sw=4 et:
local packer_exists = pcall(vim.cmd, [[packadd packer.nvim]])

if not packer_exists then
    if vim.fn.input("Download Packer? (y for yes) ") ~= "y" then
        return
    end

    local directory = string.format(
        '%s/site/pack/packer/opt/',
        vim.fn.stdpath('data')
    )

    vim.fn.mkdir(directory, 'p')

    local out = vim.fn.system(string.format(
        'git clone %s %s',
        'https://github.com/wbthomason/packer.nvim',
        directory .. '/packer.nvim'
    ))

    print(out)
    print("Downloading packer.nvim...")

    return
end

vim.cmd [[autocmd BufWritePost plugins.lua PackerCompile]]

require('packer').startup(function()
    use {'wbthomason/packer.nvim', opt = true}

    use {
        'gruvbox-community/gruvbox',
        config = function()
            vim.o.background = 'dark'
            vim.g.gruvbox_italics = true
            vim.g.gruvbox_contrast_dark = 'hard'
            vim.cmd('colorscheme gruvbox')
        end,
    }

    use {
        'glepnir/indent-guides.nvim',
        config = "require('conf.indent-guides')"
    }

    use {
        'hoob3rt/lualine.nvim',
        requires = {'kyazdani42/nvim-web-devicons', opt = true},
        config = function()
            require('lualine').setup{
                options = {
                    theme = 'powerline',
                    -- section_separator = {'|', '|'},
                    -- component_separators = {'|', '|'},
                    icons_enabled = true,
                },
                sections = {
                    lualine_a = {{'mode', upper = true}},
                    lualine_b = {{'branch', icon = ''}},
                    lualine_c = {{'filename', file_status = true}},
                    lualine_x = {'encoding', 'fileformat', 'filetype'},
                    lualine_y = {'progress'},
                    lualine_z = {'location'},
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = {'filename'},
                    lualine_x = {'location'},
                    lualine_y = {},
                    lualine_z = {}
                },
                extensions = {'fzf'},
            }
        end
    }

    use {
        'kyazdani42/nvim-tree.lua',
        config = function()
            require('conf.tree-config').setup()
        end,
        requires = {'kyazdani42/nvim-web-devicons', opt = true}
    }

    use {
        'norcalli/nvim-colorizer.lua',
        config = function()
            require('colorizer').setup()
        end,
    }

    use {
        'nvim-treesitter/nvim-treesitter',
        requires = {
            {'nvim-treesitter/nvim-treesitter-refactor', after = 'nvim-treesitter'},
            {'nvim-treesitter/nvim-treesitter-textobjects', after = 'nvim-treesitter'}
        },
        config = "require('conf.nvim-treesitter').config()",
        run = ':TSUpdate'
    }

    use {
        'neovim/nvim-lspconfig',
        config = function()
            require('conf.nvim-lspconfig')
        end,
--        requires = {
--            'nvim-lua/lsp-status.nvim'
--        },
    }

    use {
        'RishabhRD/nvim-lsputils',
        requires = {
            'RishabhRD/popfix'
        }
    }

    use {
        'nvim-lua/completion-nvim',
        requires = {
            'hrsh7th/vim-vsnip',
            'hrsh7th/vim-vsnip-integ',
            'steelsojka/completion-buffers',
            'nvim-treesitter/completion-treesitter'
        },
        setup = "require('conf.completion-nvim').setup()",
        config = "require('conf.completion-nvim').config()"
    }

    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            'nvim-lua/popup.nvim',
            'nvim-lua/plenary.nvim'
        },
        setup = "require('conf.telescope').setup()",
        config = "require('conf.telescope').config()"
    }

    use {
        'liuchengxu/vista.vim',
        setup = require('conf.vista').setup,
    }

    use {
        'mhinz/vim-startify',
        config = function()
            require('conf.startify')
        end,
    }

    use {'mhinz/vim-signify'}

    use {
        'simnalamburt/vim-mundo',
        config = function()
            vim.g.mundo_width          = 60
            vim.g.mundo_preview_bottom = true
        end,
    }

    use 'PotatoesMaster/i3-vim-syntax'

end)

