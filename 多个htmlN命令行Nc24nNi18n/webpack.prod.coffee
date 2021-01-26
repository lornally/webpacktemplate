#生产环境用的配置文件
{ CleanWebpackPlugin } = require 'clean-webpack-plugin'

{merge} = require 'webpack-merge'
web = require './webpack.web.coffee'
module.exports=merge web,
	mode: 'production'
	#plugins: [
	#	new CleanWebpackPlugin
	#]
	# 因为prod只输出一个module.exports, 所以可以优化runtime.js, 不担心覆盖问题
	#optimization:	runtimeChunk: 'single',
	#配置后台地址 //server的url
	#externals: 'webpackonfig': JSON.stringify	apiurl: 'http://39.100.155.145:30004/wuliu_back/uds/'
	#配置生产环境专用css
	#entry: app: [
	#		'./src/index.cs'
	#		'./src/index.sass'
	#		'./src/mapanel/mapanel.prod.dyna.sass'
	#	]

