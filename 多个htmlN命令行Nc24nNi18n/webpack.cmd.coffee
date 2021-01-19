# html server配置文件
{merge} = require 'webpack-merge'
base = require './webpack.base.coffee'
webpack = require 'webpack'

module.exports = merge base,
	plugins: [
		new webpack.BannerPlugin
			banner: '#!/usr/bin/env node'
			raw: true
	]
	entry:
		bin: './src/test.cs'

