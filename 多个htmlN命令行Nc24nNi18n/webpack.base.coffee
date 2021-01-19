# 基础的webpack配置文件, 不含html和cmd的单独的设置
path = require('path')
#{ CleanWebpackPlugin } = require('clean-webpack-plugin')
HtmlWebpackPlugin = require('html-webpack-plugin')
MiniCssExtractPlugin = require('mini-css-extract-plugin')

module.exports =

	module:
		rules: [
			{
				test: /\.m?js$/
				exclude: /(node_modules|bower_components)/
				use: loader: 'babel-loader'
			}
			{
				test: /\.coffee$|\.cs$/
				exclude: /(node_modules|bower_components)/
				loader: 'coffee-loader'
				options: transpile:
					presets: ['@babel/env',"@babel/react"]
					# plugins:  ["@babel/transform-runtime"]
			}
			{
				test: /\.cson$/
				use: loader: 'cson-loader'
			}
		],
	output:
		filename: '[name].js'
		path: path.resolve __dirname,'exroot/dist'
		publicPath: '.'
	#plugins: [
	#	new CleanWebpackPlugin
	#]
	optimization:
		runtimeChunk: 'single',
		splitChunks: cacheGroups: vendor:
			test: /[\\/]node_modules[\\/]/
			name: 'vendors'
			chunks: 'all'
	resolve: # 解决自动查找index.cs而不是index.js的问题 #lib的配置
		alias: mlib: path.resolve __dirname, '/Users/bergman/git/_X/code/lib/mcktools/src/'
		extensions: ['.cs', '.coffee', '.mjs', '.js']
