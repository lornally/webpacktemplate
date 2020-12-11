path = require 'path'
{ CleanWebpackPlugin } = require 'clean-webpack-plugin'
nodeExternals = require 'webpack-node-externals'
glob = require "glob"
toml=require 'toml'
yaml=require 'yamljs'
json5=require 'json5'
HtmlWebpackPlugin = require 'html-webpack-plugin'
MiniCssExtractPlugin = require 'mini-css-extract-plugin'

#先按照测试环境配置, 生产环境是不一样的.
module.exports =
	mode: 'development'
	devtool: 'inline-source-map'
	devServer: contentBase: './output/online'
  #直接配置 #本机的url
	externals: 'webpackonfig': JSON.stringify apiurl: 'http://localhost:30004/wuliu_back/uds/'
	target: 'node'
	output:
		filename: '[name].js'
		path: path.resolve __dirname,'output/online'
		publicPath: '.'
	
	entry:{
		# 正常的分离文件的entry
		app: [
			'./src/index.cs'
			'./src/index.sass'
		]
		# 引用的entry
		index: {import: './src/index.js',dependOn: 'shared'},
		another: {import: './src/another-module.js',dependOn: 'shared'},
		shared: 'lodash',
		# 为了测试所有文件都输出的netry
		(glob.sync('./src/**/**.cs').reduce (obj, el)->
			obj[path.parse(el).name] = el
			obj
		,{})...
	}
	plugins: [
		new CleanWebpackPlugin cleanStaleWebpackAssets: false # 这是为了不清除index.html, 不用ejs模板的时候需要这个
		new HtmlWebpackPlugin
			hash: true
			favicon: './favicon.ico'
			inject: true
		new MiniCssExtractPlugin
	]
	module: rules: [
		{
			test: /\.m?js$/
			exclude: /(node_modules|bower_components)/
			use: loader: 'babel-loader'
		}
		{
			test: /\.coffee$|\.cs$/
			exclude: /(node_modules|bower_components)/
			loader: 'coffee-loader'
			options: transpile: presets: ['@babel/env',"@babel/react"]
		}
		#asset/resource 发送一个单独的文件并导出 URL。之前通过使用 file-loader 实现。
		#asset/inline 导出一个资源的 data URI。之前通过使用 url-loader 实现。
		#asset/source 导出资源的源代码。之前通过使用 raw-loader 实现。
		#asset 在导出一个 data URI 和发送一个单独的文件之间自动选择。之前通过使用 url-loader，并且配置资源体积限制实现。
		{
			test: /\.cson$/
			use: loader: 'cson-loader'
		}
		{ # 图片和字体的支持可以写在一起了.
			test: /\.(png|svg|jpg|jpeg|gif|woff|woff2|eot|ttf|otf)$/i
			type: 'asset/resource'  # 这个5的写法替换了: use: ['file-loader',],
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
		}
		# 更多的数据格式支持
		{
			test: /\.(csv|tsv)$/
			exclude: /(node_modules|bower_components)/
			use: [
				'csv-loader'
			],
		}
		{
			test: /\.xml$/
			exclude: /(node_modules|bower_components)/
			use: [
				'xml-loader'
			],
		}
		{
			test: /\.toml$/
			exclude: /(node_modules|bower_components)/
			type: 'json'
			parser: parse: toml.parse
		}
		{
			test: /\.yaml$/
			exclude: /(node_modules|bower_components)/
			type: 'json'
			parser: parse: yaml.parse
		}
		{
			test: /\.json5$/
			exclude: /(node_modules|bower_components)/
			type: 'json'
			parser: parse: json5.parse
		}
	
	]
	resolve: # 解决自动查找index.cs而不是index.js的问题
		alias: mlib: path.resolve(__dirname, './src/mlib/src/')
		extensions: ['.cs', '.coffee', '.mjs', '.js']
	
	
	optimization: # 优化
		runtimeChunk: 'single',
		# 把node_modules单独打包, 单独缓存, 因为他们变化会比较少
		splitChunks: cacheGroups: vendor:
			test: /[\\/]node_modules[\\/]/
			name: 'vendors'
			chunks: 'all'

	


	



		#HtmlWebpackPlugin = require('html-webpack-plugin')
		#webpack = require('webpack')
		#path = require('path')
		
		#config =
		#	mode: 'production'
		#	entry: './path/to/my/entry/file.js'
		#	output:
		#			path: path.resolve(__dirname, 'dist')
		#			filename: 'my-first-webpack.bundle.js'
		#	module: rules: [ {
		#		test: /\.(js|jsx)$/
		#		use: 'babel-loader'
		#	} ]
		#	plugins: [
		#		new HtmlWebpackPlugin(template: './src/index.html')
		#	]
		
		#module.exports = config
		
