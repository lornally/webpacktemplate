# html server配置文件
path = require('path')

{merge} = require 'webpack-merge'
base = require './webpack.base.coffee'
HtmlWebpackPlugin = require 'html-webpack-plugin'
MiniCssExtractPlugin = require 'mini-css-extract-plugin'

module.exports = merge base,
	module:
		rules: [
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
				]
			}
		]
	entry:
		pop: [
			'./src/pop.js'
			'./src/pop.sass'
		]
		a1: [
			'./src/a1.cs'
			'./src/a1.sass'
		]
		b1: [
			'./src/b1.js'
			'./src/b1.sass'
		]
		rei: [ # 真正的示例代码
			'./src/rei.cs'
			'./src/rei.sass'
			'./src/rei.module.sass'

		]
	output: path: path.resolve __dirname,'exroot/html'
	plugins: [
		new HtmlWebpackPlugin
			hash: true
			favicon: path.resolve __dirname,'./favicon.ico'
			template: path.resolve __dirname, './src/rei.ejs'
			filename: path.resolve __dirname, './exroot/html/index.html'
			chunks: ['rei']
			cache: false #todo debug
		new MiniCssExtractPlugin
	]
	devServer:
		contentBase: path.resolve __dirname, './exroot/html'
		watchContentBase: true # todo debug
		port: 8080

	resolve: alias: mlib: path.resolve __dirname, '/Users/bergman/git/_X/code/lib/mcktools/src/indexhtml.cs'
	mode: 'development'
	devtool: 'inline-source-map'
