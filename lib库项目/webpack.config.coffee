path = require('path')
{ CleanWebpackPlugin } = require('clean-webpack-plugin')
nodeExternals = require('webpack-node-externals')
glob = require("glob")


#先按照测试环境配置, 生产环境是不一样的.
module.exports =
	mode: 'development'
	devtool: 'inline-source-map'
	target: 'node'
	output:
		path: path.resolve(__dirname, 'dist/api')
		filename: '[name].js'
		library: 'mlib' # 指定library的name
		libraryTarget: 'umd' # 指定library编译的兼容性, common, es6, amd, umd, link...
	externals:[ # 把lodash声明为外部的环境依赖, 这样运行库的时候回进行环境监测, 并且也避免把bodash打包到库里面.
		lodash:
			commonjs: 'lodash'
			commonjs2: 'lodash'
			amd: 'lodash'
			root: '_'
		react: 'react'
		subtract: ['./math', 'subtract']
		nodeExternals() #这个很有用, 排除所有node_modules
		/^library\/.+$/
	]
	entry: # 生成多个entry, 对象格式
		glob.sync('./src/**.cs').reduce (obj, el)->
			obj[path.parse(el).name] = el
			obj
		,{}
		
		
	plugins: [
		new CleanWebpackPlugin({cleanStaleWebpackAssets: false})
	],
	module:rules:[
		{
			test: /\.m?js$/
			exclude: /(node_modules|bower_components)/
			use:
				loader: 'babel-loader'
		}
		{
			test: /\.coffee$|\.cs$/,
			loader: 'coffee-loader'
			options: {
				transpile: {
					presets: ['@babel/env']
				}
			}
		}
		{
			test: /\.cson$/
			use:
				loader: 'cson-loader'
		}
	]

	
	resolve: # 解决自动查找index.cs而不是index.js的问题
		alias: mlib: path.resolve(__dirname, './src/')
		extensions: ['.cs', '.coffee', '.mjs', '.js']
