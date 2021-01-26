# html server配置文件
path = require('path')

{merge} = require 'webpack-merge'
base = require './webpack.base.coffee'
web = require './webpack.web.coffee'

HtmlWebpackPlugin = require 'html-webpack-plugin'
MiniCssExtractPlugin = require 'mini-css-extract-plugin'

module.exports = merge web,

	mode: 'development'
	devtool: 'inline-source-map'

