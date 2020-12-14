path = require('path')
{ CleanWebpackPlugin } = require('clean-webpack-plugin')

HtmlWebpackPlugin = require('html-webpack-plugin')
MiniCssExtractPlugin = require('mini-css-extract-plugin')

nodeExternals = require('webpack-node-externals')
glob = require("glob")



#先按照测试环境配置, 生产环境是不一样的.
module.exports =
	mode: 'development'
	devtool: 'inline-source-map'
	target: 'node'

	output:
		path: path.resolve(__dirname, 'dist/api')
		#filename: '[name].[contenthash].js' # 这个会导致vscode的调试不生效. 好神奇.
		filename: '[name].js'
		library: 'mlib' # 指定library的name
		libraryTarget: 'umd' # 指定library编译的兼容性, common, es6, amd, umd, link...
		#publicPath: '.'

	externals:[ # 把lodash声明为外部的环境依赖, 这样运行库的时候回进行环境监测, 并且也避免把bodash打包到库里面.
		#lodash:
		#	commonjs: 'lodash'
		#	commonjs2: 'lodash'
		#	amd: 'lodash'
		#	root: '_'
		#react: 'react'
		#subtract: ['./math', 'subtract']
		nodeExternals() #这个很有用, 排除所有node_modules
		/^library\/.+$/
	]
	entry: # 生成多个entry, 对象格式
		glob.sync('./src/**.cs').reduce (obj, el)->
			obj[path.parse(el).name] = el
			obj
		,{}
		
	plugins: [
		new CleanWebpackPlugin cleanStaleWebpackAssets: false
		#new HtmlWebpackPlugin
		#	hash: true
		#	avicon: './favicon.ico'
		#new MiniCssExtractPlugin
	],
	module:rules:[
		{
			test: /\.m?js$/
			exclude: /(node_modules|bower_components)/
			use: loader: 'babel-loader'
		}
		{
			test: /\.coffee$|\.cs$/,
			exclude: /(node_modules|bower_components)/
			loader: 'coffee-loader'
			options: transpile: presets: ['@babel/env',"@babel/react"]
		}
		{
			test: /\.cson$/
			use: loader: 'cson-loader'
		}
		{
			test: /\.((c|sa|sc)ss)$/i
			exclude: /node_modules/
			use: [
				MiniCssExtractPlugin.loader
				{
					loader: 'css-loader'
					options:
						# Run `postcss-loader` on each CSS `@import`, do not forget that `sass-loader` compile non CSS `@import`'s into a single file
						# If you need run `sass-loader` and `postcss-loader` on each CSS `@import` please set it to `2`
						importLoaders: 1,
						# Automatically enable css modules for files satisfying `/\.module\.\w+$/i` RegExp.
						modules: auto: true
				}
				'postcss-loader'
				'sass-loader'
			]
		}
	]

	optimization:
		runtimeChunk: 'single',
		splitChunks: cacheGroups: vendor:
			test: /[\\/]node_modules[\\/]/
			name: 'vendors'
			chunks: 'all'

	resolve: # 解决自动查找index.cs而不是index.js的问题
		alias: mlib: path.resolve(__dirname, './src/')
		extensions: ['.cs', '.coffee', '.mjs', '.js']
