###### 两条路都可以走通

1. 使用全局变量`__webpack_hash__`
2. 用defineplugin制造一个全局变量

```
new webpack.DefinePlugin({
		//VERSION: ''+Date.now,//'[contenthash]',	
		BUILT_AT: webpack.DefinePlugin.runtimeValue(Date.now, [fileDep]),

	}),


```
