#生产环境用的配置文件
{merge} = require 'webpack-merge'
common = require './webpack.common.coffee'
module.exports=merge common,
	mode: 'production'
	#配置后台地址 //server的url
	#externals: 'webpackonfig': JSON.stringify	apiurl: 'http://39.100.155.145:30004/wuliu_back/uds/'
	#配置生产环境专用css
	#entry: app: [
	#		'./src/index.cs'
	#		'./src/index.sass'
	#		'./src/mapanel/mapanel.prod.dyna.sass'
	#	]

