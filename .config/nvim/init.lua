require("config.options") --- options
require("config.keymaps") --- keymaps
require("config.vscode") -- vscode
require("config.api") -- api
require("lazy.lazy")  -- lazy

-- colorbuddy setup
local colorbuddy = require('colorbuddy')
local colors = colorbuddy.colors
local styles = colorbuddy.styles
local Group = colorbuddy.Group

Group.new('CursorLine', colors.none, colors.base03, styles.NONE, colors.base1) 
Group.new('CursorLineNr', colors.yellow, colors.black, styles.NONE, colors.base1) 
Group.new('Visual', colors.none, colors.base03, styles.reverse) 

local test = "hello neovim"

print(test)

