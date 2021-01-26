# 为了解决webpack serve问题临时的config
path = require('path')

{merge} = require 'webpack-merge'
base = require './webpack.base.coffee'
web = require './webpack.web.coffee'

HtmlWebpackPlugin = require 'html-webpack-plugin'
MiniCssExtractPlugin = require 'mini-css-extract-plugin'

module.exports = merge web,

	mode: 'development'
	devtool: 'inline-source-map'

