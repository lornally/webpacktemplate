# 基础的webpack配置文件
path = require('path')
{ CleanWebpackPlugin } = require('clean-webpack-plugin')
HtmlWebpackPlugin = require('html-webpack-plugin')
MiniCssExtractPlugin = require('mini-css-extract-plugin')

module.exports =

	# todo 这两行是测试用的, 生产环境要注释掉
	mode: 'development'
	devtool: 'inline-source-map'

	

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
			{

				test: /\.((c|sa|sc)ss)$/i
				exclude: /node_modules/
				use: [
					MiniCssExtractPlugin.loader
					{
						loader: 'css-loader'
						options:
							importLoaders: 1
							modules: auto: true
					}
					'postcss-loader'
					'sass-loader'
				],
			},

		],
	#entry: mlib: './src/mlib/src/index.cs' #lib的配置
	entry:
		pop: [
			'./src/pop.js'
			'./src/pop.sass'
		]
		a1: [
			'./src/a1.js'
			'./src/a1.sass'
		]
		b1: [
			'./src/b1.js'
			'./src/b1.sass'
		]
	output:
		#filename: '[name].[contenthash].js'
		filename: '[name].js'

		path: path.resolve __dirname,'exroot/dist'
		publicPath: '.'
		#library: 'mlib' # 指定library的name #lib的配置
		#libraryTarget: 'umd' # 指定library编译的兼容性, common, es6, amd, umd, link...
		#libraryExport: 'mlib' #指定暴露的内容, 在entry设置
	plugins: [
		new CleanWebpackPlugin
		new HtmlWebpackPlugin
			hash: true
			favicon: './favicon.ico'
			template: './src/pop.ejb', # relative path to the HTML files
			filename: 'pop.html', # output HTML files
			chunks: ['pop'] # respective JS files

		new HtmlWebpackPlugin
			hash: true
			favicon: './favicon.ico'
			template: './src/a1.ejb', # relative path to the HTML files
			filename: 'a1.html', # output HTML files
			chunks: ['a1'] # respective JS files
		new HtmlWebpackPlugin
			hash: true
			favicon: './favicon.ico'
			template: './src/b1.ejb', # relative path to the HTML files
			filename: 'b1.html', # output HTML files
			chunks: ['b1'] # respective JS files
		new MiniCssExtractPlugin
	]



	optimization:
		runtimeChunk: 'single',
		splitChunks: cacheGroups: vendor:
			test: /[\\/]node_modules[\\/]/
			name: 'vendors'
			chunks: 'all'
	resolve: # 解决自动查找index.cs而不是index.js的问题 #lib的配置
		alias: mlib: path.resolve __dirname, '/Users/bergman/git/_X/code/lib/mcktools/src/'
		extensions: ['.cs', '.coffee', '.mjs', '.js']
