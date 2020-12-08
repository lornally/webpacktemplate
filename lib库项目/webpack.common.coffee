path = require('path')
{ CleanWebpackPlugin } = require('clean-webpack-plugin')
nodeExternals = require('webpack-node-externals')
glob = require("glob")

HtmlWebpackPlugin = require('html-webpack-plugin')
MiniCssExtractPlugin = require('mini-css-extract-plugin')
#先按照测试环境配置, 生产环境是不一样的.
module.exports =
	
	output:
		filename: '[name].js'

		path: path.resolve __dirname,'output/online'
		publicPath: '.'

	#externals:[ # 把lodash声明为外部的环境依赖, 这样运行库的时候回进行环境监测, 并且也避免把bodash打包到库里面.
	#	lodash:
	#		commonjs: 'lodash'
	#		commonjs2: 'lodash'
	#		amd: 'lodash'
	#		root: '_'
	#	react: 'react'
	#	subtract: ['./math', 'subtract']
	#	nodeExternals() #这个很有用, 排除所有node_modules
	#	/^library\/.+$/
	#]
	
		
		
	plugins: [
		#new CleanWebpackPlugin({cleanStaleWebpackAssets: false})
		new CleanWebpackPlugin
		new HtmlWebpackPlugin
			hash: true
			favicon: './favicon.ico'
			inject: true
		new MiniCssExtractPlugin
	],
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

	
	resolve: # 解决自动查找index.cs而不是index.js的问题
		alias: mlib: path.resolve(__dirname, './src/mlib/src/')
		extensions: ['.cs', '.coffee', '.mjs', '.js']
	optimization:
		runtimeChunk: 'single',
		splitChunks: cacheGroups: vendor:
			test: /[\\/]node_modules[\\/]/
			name: 'vendors'
			chunks: 'all'
