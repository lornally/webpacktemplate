#开发用的webpack配置文件
{merge} = require 'webpack-merge'
html = require './webpack.html.coffee'
cmd = require './webpack.cmd.coffee'

devhtml=merge html,
	mode: 'development'
	devtool: 'inline-source-map'
	#target: 'node'
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

devcmd =merge cmd,
	mode: 'development'
	devtool: 'inline-source-map'
	target: 'node'

module.exports=[devcmd, devhtml]
#module.exports=[devhtml,devcmd]
