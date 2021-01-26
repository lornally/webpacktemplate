# node cmd配置文件
path = require 'path'
glob = require 'glob'


{merge} = require 'webpack-merge'
base = require './webpack.base.coffee'
webpack = require 'webpack'

module.exports = merge base,
	plugins: [
		new webpack.BannerPlugin
			banner: '#!/usr/bin/env node'
			raw: true
			test: ['bin','test','cmd']
	]
	entry:{
		bin: './src/test.cs'
		# 这个要指明目录,web专属内容cmd是编译不过去的, 比如css module
		#(glob.sync('./src/**/**.cs').reduce (obj, el)->
		#	obj[path.parse(el).name] = el
		#	obj
		#,{})...
	}
	output: path: path.resolve __dirname,'exroot/cmd'
	target: 'node'
	resolve: alias: mlib: path.resolve __dirname, '/Users/bergman/git/_X/code/lib/mcktools/src/indexcmd.cs'
