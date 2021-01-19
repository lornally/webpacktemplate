- 官方文档就有多页面: https://github.com/jantimon/html-webpack-plugin#generating-multiple-html-files
- stackoverflow
  - https://stackoverflow.com/questions/52434167/how-can-i-use-multiple-entries-in-webpack-alongside-multiple-html-files-in-htmlw
  - https://stackoverflow.com/questions/39798095/multiple-html-files-using-webpack

###### 配置文件样例webpack.common.coffee

```coffeescript
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
	output:
		#filename: '[name].[contenthash].js'
		filename: '[name].js'

		path: path.resolve __dirname,'exroot/dist'
		publicPath: '.'
		#library: 'mlib' # 指定library的name #lib的配置
		#libraryTarget: 'umd' # 指定library编译的兼容性, common, es6, amd, umd, link...
		#libraryExport: 'mlib' #指定暴露的内容, 在entry设置
	plugins: [
		new CleanWebpackPlugin
		new HtmlWebpackPlugin
			hash: true
			favicon: './favicon.ico'
			template: './src/pop.ejb', # relative path to the HTML files
			filename: 'pop.html', # output HTML files
			chunks: ['pop'] # respective JS files

		new HtmlWebpackPlugin
			hash: true
			favicon: './favicon.ico'
			template: './src/a1.ejb', # relative path to the HTML files
			filename: 'a1.html', # output HTML files
			chunks: ['a1'] # respective JS files
		new HtmlWebpackPlugin
			hash: true
			favicon: './favicon.ico'
			template: './src/b1.ejb', # relative path to the HTML files
			filename: 'b1.html', # output HTML files
			chunks: ['b1'] # respective JS files
		new MiniCssExtractPlugin
	]
```

