# 基础的webpack配置文件, 不含html和cmd的单独的设置
path = require 'path'
{ CleanWebpackPlugin } = require 'clean-webpack-plugin'
HtmlWebpackPlugin = require 'html-webpack-plugin'
MiniCssExtractPlugin = require 'mini-css-extract-plugin'
nodeExternals = require 'webpack-node-externals'


module.exports =
	#externals:[
	#	nodeExternals() #这个很有用, 排除所有node_modules, 但是会引起webpack serve错误, 因此注释掉
	#	/^library\/.+$/
	#]
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
		]
	output:
		filename: '[name].js'
		#library: 'mh' # 指定library的name
		#libraryTarget: 'umd' # 指定library编译的兼容性, common, es6, amd, umd, link...
		# path: path.resolve __dirname,'exroot/dist'
		# 不同的内容应该输出到不同的目录. 不然无法正常运行
		#publicPath: '.'
	plugins: [
		new CleanWebpackPlugin
	]
	optimization:
		runtimeChunk: 'single'
		splitChunks: cacheGroups: vendor:
			test: /[\\/]node_modules[\\/]/
			name: 'vendors'
			chunks: 'all'
	#resolve: # 解决自动查找index.cs而不是index.js的问题 #lib的配置
	#	alias: mlib: path.resolve __dirname, '/Users/bergman/git/_X/code/lib/mcktools/src/'
	#	extensions: ['.cs', '.coffee', '.mjs', '.js']
