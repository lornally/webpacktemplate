###### 为了测试打包多个js文件

```coffeescript
entry: 
	app:  import: './app.js', dependOn: 'react-vendors'  # 这个trunk依赖下面一个
  'react-vendors': ['react', 'react-dom', 'prop-types'] # 这里数组是这一个chunk的组成
  # 如果entry直接就传入一个字符串或字符串数组，chunk 会被命名为 main
```

- 使用glob可以, 参考: 打包一个库项目.md, lib库项目

```sh
 npm install webpack-glob --save-dev #安装glob
```

```coffeescript
# webpack配置文件
glob = require "glob"
# ...
entry:
  glob.sync('./src/**.cs').reduce (obj, el)->
    obj[path.parse(el).name] = el
    obj
  ,{}
  
# 上面这个配置其实不可以
entry:{
		# bin: './src/test.cs' #直接指定测试文件, 是比较柔软的做法
		# 这个要指明目录,web专属内容cmd是编译不过去的, 比如css module
		(glob.sync('./src/**/**.cs').reduce (obj, el)->
			obj[path.parse(el).name] = el
			obj
		,{})...
	}
```

###### 

