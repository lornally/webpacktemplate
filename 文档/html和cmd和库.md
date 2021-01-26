###### 参考项目

- 多个html命令行Nc24nNi18n

###### 整体结构

- webpack.base.coffee, 基础设置
- webpack.html.coffee, merge了基础设置, 并且加上了html的单独设置, 主要是output
- webpack.cmd.coffee, merge了基础设置, 并且加上cmd单独设置, 注意output和上面不能重复
- webpack.dev.coffee, 开发的配置, 同时输出html和cmd
- webpack.prod.coffee, 生产的配置, 应该只有html server的设置. (一般情况下)

###### 问题

1. 共用output目录后患无穷

   1. cleanwebpackplugin会有问题, 因为多个项目公用的base文件如果引入这个, 那么后执行的配置就会删除前面配置的输出, 使用命令行删除目录, 可以解决这个问题

      ```sh
      rm -rf
      # package.json
      "make": "rm -rf exroot/dist && webpack --config webpack.dev.coffee && chmod u+x ./exroot/dist/bin.js",
      ```

   2. optimization:    runtimeChunk: 'single', 这个也会有问题, runtime.js会互相覆盖, 注释掉他就可以解决问题.

   3. 其实这两个问题都是因为共用了输出目录, 这个错了, 应该用不同的输出目录.

3. cmd/html分别target:node和devserver

4. html项目不能识别shebang, 因此要指定那些模块需要生成shebang

   ```coffeescript
   new webpack.BannerPlugin
   			banner: '#!/usr/bin/env node'
   			raw: true
   			test: ['bin','test','cmd']
   ```

5. 因为web下面会缺乏node的很多库(本文后续有库的代码示例), 因此有些输出必须是cmd only. 

   1. entry要区分输出内容, 
   3. coffee的index文件也要分开indexcmd.cs和indexhtml.cs
   
5. webpack serve不显示html而是显示目录, 有两个原因

   1. module.exports了array
   2. publicpath设置错误

   ```sh
   	output: publicPath: '.' # 这个也可能引起webpack serve不正常
   ```

   

###### 自己的参考

- post: 2021-01-07-node调用命令行
- post: 2020-12-28-softlink,hardlink,shortcut,firmlink
- lornpug: doc/技术方案

###### node的本地可以npm执行的库

```json
// 编辑package.json
"name": "cn",
"version": "1.0.0",
"bin": "./exroot/dist/bin.js",
"scripts": {
  "test": "echo \"Error: no test specified\" && exit 1",
  "webpack": "webpack",
  "build": "webpack --config webpack.prod.coffee",
  "dev": "webpack serve --config webpack.dev.coffee",
  "prod": "webpack serve --config webpack.prod.coffee",
  "make": "webpack --config webpack.dev.coffee && chmod u+x ./exroot/dist/bin.js", //注意这里要设置bin的权限, 地址和上面的bin设置一致
  "watch": "webpack --watch --config webpack.dev.coffee"
},

// webpack.common.coffee
webpack = require 'webpack'
plugins: [
	new webpack.BannerPlugin //这里是shebang插入的插件
		banner: '#!/usr/bin/env node'
		raw: true
]
entry: //这里指明编辑那个文件到bin.js
	bin: './src/test.cs'
output:
  filename: '[name].js'
  path: path.resolve __dirname,'exroot/dist'
  publicPath: '.'
// 因为命令执行, webpack配置文件需要设置
target=node

// 然后命令行执行
yarn
yarn make
yarn link
```

### cmd详细说明

###### package.json的结构

```json
bin: '.pathto/script'  // node编写的命令行工具, npm分发的, 用包名直接执行.

//下面这个写法, 执行文件就是name指定的myxxx
{ "name": "myxxx"
, "version": "1.2.5"
, "bin": "./path/to/program" } //这里路径以.开头

// 比如coffee的示例:
"main": "./lib/coffeescript/index", // 库项目需要指定的入口唯一, 不是库项目, 则不需要弄这个
"module": "./lib/coffeescript-browser-compiler-modern/coffeescript.js",
"browser": "./lib/coffeescript-browser-compiler-legacy/coffeescript.js",
"bin": {
  "coffee": "./bin/coffee",
  "cake": "./bin/cake"
},
"scripts": {
  "test": "node ./bin/cake test",
  "test-harmony": "node --harmony ./bin/cake test"
},
```

###### shebang

```sh
#!/usr/bin/env node
//这个要放到js文件的第一行
```

- 如果用webpack处理shebang那么需要插件

```coffeescript
# 参考 https://stackoverflow.com/questions/40755149/how-to-keep-my-shebang-in-place-using-webpack
# 使用 BannerPlugin, 他会自动插入shebang到js, 因此cs里面不再需要声明shebang
webpack = require 'webpack'
plugins: [
    new webpack.BannerPlugin({ banner: "#!/usr/bin/env node", raw: true }),
]
```

###### link步骤

- package.json

```json
"name": "lornpug",
"bin":{
  "lornpug": "./bin/lornpug",
  "lorn": "./bin/lornpug",
  "pug": "./bin/lornpug",
  "lpg": "./bin/lornpug" //缩写lp不可以, 因为lp是打印文件的意思
},
//如果想用lp, 那么需要编辑.zshrc
alias lp="lpg"
```

- 然后编辑bin/lornpug, 这里没有扩展名

```sh
#!/usr/bin/env node
console.log('hahahahahahaha');
return
```

- 此时命令行

```sh
node ./bin/lornpug #这里有正确结果
```

- 此时link

```sh
yarn link # 或者 npm link 也行
lornpug # 此时可能报错permission denied
chmod u+x lornpug # 添加权限之后记得ll检查是否有x权限了
# 如果用webpack处理输出文件, 那么每次生成都会面临这个权限问题, 因此package.json需要修改为:
"scripts": {
		"build": "webpack && chmod u+x ./dist/api/bin/bin.js",
},
# 如果报错文件找不到, 那么要看一下package.json指定的./bin/lornpug存在吗?
yarn unlink # 解除这个软链接, 毕竟目前啥也不干
```

- link 换成 install -g也是可以的

```sh
npm install -g # 怎么uninstall要先考虑好.
```

- 如果不是全局link方式, 而是本地yarn xxx执行

```json
//如果在package.json添加了	
"scripts": {
  "lp":"node ./bin/lornpug",
  "lorn":"lornpug"
},
//此时下面两个命令行都会出结果
yarn lp
yarn lorn 
```

- 是否添加.npmignore呢? 如果已经有了.gitignore, 那么就不必搞.npuignore了

- 测试用的可执行文件

```
console.log('表演开始show time');
console.log("process.cwd() = " + process.cwd());
console.log("__dirname = " + __dirname);
console.log("参数",process.argv);
```

### html的写法

```js
const HtmlWebpackPlugin=require('html-webpack-plugin');
//html的处理,1/2 官方推荐使用插件, 这个用在webpack.config.js, 可以用模板
const webpackdevconfig={ 
	module: {
		rules: [
			{
				test: /\.(png|svg|jpg|gif)$/,
				use: [
					//html的处理方法, 2/2,或者可以用file-loader也可以copy过去.
					'file-loader',
				],
			},
		]
	},
	plugins: [
		new CleanWebpackPlugin(),
		//CleanWebpackPlugin, 因为他的存在, 所以git控制的目录要在上一层.
		new HtmlWebpackPlugin({
			title: '管理缓存',
		}),
	],
	output: {
		filename: '[name].[contenthash].js',
		//使用filename: '[name].[contenthash].js', 保证有更新就刷缓存. 
		path: path.resolve(__dirname,'output/online'),
		//这里output中的文件不会被自动清除, 所以可以设置为git控制的目录.
		publicPath: '/',
	},
	

};
```

### 库的处理

作为库项目还有其特殊性:

1. 库的index.cs作为模块输出, 也要区分cmd和html, 相应的webpack里面要配置entry: index
2. 同样resolve: alias: mlib: 也要区分cmd和html

###### 库项目的示例

示例配置代码

```coffeescript
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
		index: './src/indexcmd.cs'
		(glob.sync('./src/**/**.cs').reduce (obj, el)->
			obj[path.parse(el).name] = el
			obj
		,{})...
	}
	output: path: path.resolve __dirname,'exroot/cmd'
	target: 'node'
	resolve: alias: mlib: path.resolve(__dirname, './exroot/cmd')
```

示例indexcmd.cs

```coffeescript
import icore from './indexcore.cs'
#export {default as file} from 	'./file.cs'
import file from './file.cs'
export default {
	file
	icore...
}
```

###### 引入这个库的写法

```coffeescript
# 本地引入必须引入源文件
resolve: alias: mlib: path.resolve __dirname, '/Users/bergman/git/_X/code/lib/mcktools/src/indexhtml.cs'

# 错误的写法: 直接引入编译好的文件是不可以的
resolve:
		alias: mlib: path.resolve __dirname, '/Users/bergman/git/_X/code/lib/mcktools/exroot/html'
		extensions: ['.cs', '.coffee', '.mjs', '.js']
```

###### cs的库export的index的写法

```coffeescript
# indexcmd示例
export * from './indexcore.cs'


# 有问题的写法, 如果indexcore.cs有修改那么这个indexcmd.cs也必须同步修改.
export {	color,	random, 	time} from './indexcore.cs'
export {default as file} from 	'./file.cs'
export {default as cmd} from 	'./cmd.cs'

export default {# 这句也是错误的, 会报错file等等未定义
	file
	cmd
	color,	random, 	time
}
```

