path = require('path')
{ CleanWebpackPlugin } = require('clean-webpack-plugin')

HtmlWebpackPlugin = require('html-webpack-plugin')
MiniCssExtractPlugin = require('mini-css-extract-plugin')
nodeExternals = require 'webpack-node-externals'


#先按照测试环境配置, 生产环境是不一样的.
module.exports =
	#externals:[
	#	nodeExternals() #这个很有用, 排除所有node_modules
	#	#/^library\/.+$/
	#]
	mode: 'development'
	devtool: 'inline-source-map'
	output:
		path: path.resolve(__dirname, 'dist/api')
		filename: '[name].js'
	#devServer: 默认值就ok的.
	#	contentBase: './dist/api'
	#	watchContentBase: true
	#	port: 8080
	entry:
		app: ['./src/index.cs', './src/style.sass']
		rei: [ # 真正的示例代码
			'./src/rei.cs'
			'./src/rei.sass'
		]
	plugins: [
		new CleanWebpackPlugin cleanStaleWebpackAssets: false
		new HtmlWebpackPlugin
			hash: true
			favicon: './favicon.ico'
			template: './src/pop.ejs'# relative path to the HTML files
			filename: 'pop.html' # output HTML files
			chunks: ['pop'] # respective JS files
		new HtmlWebpackPlugin
			hash: true
			avicon: './favicon.ico'
			template: './src/rei.ejs'
			#filename: 'index.html' 默认就是index
			chunks: ['rei']
		new MiniCssExtractPlugin
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
resolve: alias: mlib: path.resolve __dirname, '/Users/bergman/git/_X/code/lib/mcktools/src/indexweb.cs'
optimization:
	runtimeChunk: 'single'
	splitChunks: cacheGroups: vendor:
		test: /[\\/]node_modules[\\/]/
		name: 'vendors'
		chunks: 'all'
