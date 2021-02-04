#开发用的webpack配置文件
{merge} = require 'webpack-merge'
web = require './webpack.web.coffee'
cmd = require './webpack.cmd.coffee'

dev=
	mode: 'development'
	devtool: 'inline-source-map'
devweb=merge web,dev,
	name: 'site'

  #直接配置 #本机的url
	#externals: 'webpackonfig': JSON.stringify apiurl: 'http://localhost:30004/wuliu_back/uds/'

devcmd =merge cmd,dev
module.exports=[devcmd, devweb]
#module.exports=[devweb,devcmd]
