path = require 'path'
{ CleanWebpackPlugin } = require 'clean-webpack-plugin'


#先按照测试环境配置, 生产环境是不一样的.
module.exports =
	mode: 'development'
	devtool: 'inline-source-map'
	target: 'node'
	output:
			path: path.resolve __dirname, 'dist/api'
			filename: '[name].js'
	entry: './src/index.cs'
	plugins: [
		new CleanWebpackPlugin cleanStaleWebpackAssets: false
	]
	module: rules: [
		{
			test: /\.m?js$/
			exclude: /(node_modules|bower_components)/
			use: loader: 'babel-loader'
		}
		{
			test: /\.coffee$|\.cs$/
			loader: 'coffee-loader'
			options: transpile: presets: ['@babel/env']
		}
		#asset/resource 发送一个单独的文件并导出 URL。之前通过使用 file-loader 实现。
		#asset/inline 导出一个资源的 data URI。之前通过使用 url-loader 实现。
		#asset/source 导出资源的源代码。之前通过使用 raw-loader 实现。
		#asset 在导出一个 data URI 和发送一个单独的文件之间自动选择。之前通过使用 url-loader，并且配置资源体积限制实现。
		{
			test: /\.cson$/
			use: loader: 'cson-loader'
		}
		{
			test: /\.(png|svg|jpg|jpeg|gif)$/i
			type: 'asset/resource'  # 这个5的写法替换了: use: ['file-loader',],
		}
		{
			test: /\.(woff|woff2|eot|ttf|otf)$/i
			type: 'asset/resource'
		}
	]

	


	



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
		
