```coffeescript
target #默认就是web
mode #默认是生产环境
devServer: #这些都是不必写的默认值
		contentBase: './exroot/web'
		watchContentBase: true
		port: 8080
new HtmlWebpackPlugin
	filename: 'index.html' #默认就是index
```

