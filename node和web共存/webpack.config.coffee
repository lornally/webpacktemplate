path = require 'path'
HtmlWebpackPlugin = require 'html-webpack-plugin'
{ CleanWebpackPlugin } = require 'clean-webpack-plugin'



cmd =
	mode: 'development'
	devtool: 'inline-source-map'
	target: 'node'
	
	output:
		path: path.resolve __dirname, 'dist/cmd'
		filename: 'lib.node.js'



html =
	mode: 'development'
	devtool: 'inline-source-map'
	entry:
		d1: './src/d1.js',
		d2: './src/d2.js'
	

	output:
		path: path.resolve __dirname, 'dist/html'
		filename: '[name].[contenthash].js'
	plugins: [
		new CleanWebpackPlugin cleanStaleWebpackAssets: false
		new HtmlWebpackPlugin	title: 'Development'
	]
	devServer: contentBase: './dist/html'

module.exports=[html,cmd]

#module.exports = [ cmd, html ]

