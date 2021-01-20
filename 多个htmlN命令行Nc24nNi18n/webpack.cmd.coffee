# node cmd配置文件
path = require('path')

{merge} = require 'webpack-merge'
base = require './webpack.base.coffee'
webpack = require 'webpack'

module.exports = merge base,
	plugins: [
		new webpack.BannerPlugin
			banner: '#!/usr/bin/env node'
			raw: true
	]
	entry:{
		bin: './src/test.cs'
		(glob.sync('./src/**/**.cs').reduce (obj, el)->
			obj[path.parse(el).name] = el
			obj
		,{})...
	}
	output: path: path.resolve __dirname,'exroot/cmd'
	target: 'node'
