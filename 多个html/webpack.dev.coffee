#开发用的webpack配置文件
path = require('path')
{merge} = require 'webpack-merge'
common = require './webpack.common.coffee'
glob = require("glob")

module.exports=merge common,{
	mode: 'development'
	devtool: 'inline-source-map'
	#entry:{
	#	app: [
	#		'./src/index.cs'
	#		'./src/index.sass'
	#	]
	#	#(glob.sync('./src/**/**.cs').reduce (obj, el)->
	#	#	obj[path.parse(el).name] = el
	#	#	obj
	#	#,{})...
	#}
	#devServer: contentBase: './output/online'
  #直接配置 #本机的url
	#externals: 'webpackonfig': JSON.stringify apiurl: 'http://localhost:30004/wuliu_back/uds/'
}
