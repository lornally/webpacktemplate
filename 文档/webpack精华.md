> 有很多文档分散在webpack样板项目的各个子目录里面.

###### webpack的优势

- 用事情组织代码, 而不是用类型组织代码, 各种类型混在一起很棒.
- 确实只能, 引入的包如果没有实际使用, 那么对代码就没有影响. 

###### 打包我的map项目.  

1. 分离生产打包和测试打包
   1. 测试打包针对测试server.
   2. 生产打包所有内容都打到dist目录, 并且有单独的端口和地址配置. 
   3. 传不同的git remote, gitignore分离不同的remote
1. 我的blog继续使用pages, 但是抛弃Jekyll
   1. 文档和图片混排, 其实是说webpack能搞定静态页面吗? 不是单页应用的那种.
2. 我的插件使用webpack打包, 
   1. 解决我全局i18n问题吗?
   2. 解决我多浏览器插件问题吗?
   3. 解决插件js加载顺序问题吗? 所有需要的包, 不再global, 而是直接引入, 压缩. 能
4. 兼容最新的webpack cli 4

###### 兼容cli 4

```js
//配置文件: package.json  
const v4={
  "scripts": {
    "build": "webpack", //v4 默认product, 因此不必-p
    "dev": "webpack serve",
  }
};
```

###### package.json中设置, 运行多个指令,  并且分别生成测试结果

```json
"scripts": {
  "test": " webpack >webpack.log &&  node ./dist/api/api.js > test.json",
},
```

###### 生产包和测试包分离

	- https://webpack.docschina.org/guides/production/
	- 不同的环境用mode: development, mode: production区分
	- 第一种写法: 不同的环境使用不同的配置文件
	- 公用的放到common里面

```sh
npm install --save-dev webpack-merge #这个可以包含common配置
```

```js
//webpack.common.js
const path = require('path');
const { CleanWebpackPlugin } = require('clean-webpack-plugin');
const HtmlWebpackPlugin = require('html-webpack-plugin');

module.exports = {
  entry: {
    app: './src/index.js',
  },
  plugins: [
    new CleanWebpackPlugin(),
    new HtmlWebpackPlugin({
      title: 'Production',
    }),
  ],
  output: {
    filename: '[name].bundle.js',
    path: path.resolve(__dirname, 'dist'),
  },
};

//webpack.dev.js
const { merge } = require('webpack-merge');
const common = require('./webpack.common.js');

module.exports = merge(common, {
  mode: 'development',
  devtool: 'inline-source-map',
  devServer: {
    contentBase: './dist',
  },
});

//webpack.prod.js
const { merge } = require('webpack-merge');
const common = require('./webpack.common.js');

module.exports = merge(common, {
  mode: 'production',
});
```

```json
//package.json
"scripts": {
  "start": "webpack serve --open",
  "start": "webpack serve --open --config webpack.dev.js",
  "build": "webpack"
  "build": "webpack --config webpack.prod.js"
}
```



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
	//不同环境配置是生产和开发环境差异的一个解决方案
	externals: { //直接配置
    //Config这个key就是未来js要用的. 
		'Config': JSON.stringify(process.env.NODE_ENV==='production'? {
			serverUrl: "https://myserver.com"
		}:{
				serverUrl: "http://localhost:8090"
			})
	},
	externals2: { //配置文件配置
		'Config': JSON.stringify(process.env.NODE_ENV==='production'? require('./config.prod.json'):require('./config.dev.json'))
	},

};

```


- 自己的js文件中


```js
var Config = require('Config')
fetchData(Config.serverUrl + '/Enterprises/...')

//react
import Config from 'Config';
axios.get(this.app_url, {
  'headers': Config.headers
}).then(...);
```

- 第二种方法,webpack.config.js 配置文件用函数写法

```js
module.exports = function(env, argv) {
  return {
    mode: env.production ? 'production' : 'development',
    devtool: env.production ? 'source-map' : 'eval',
     plugins: [
       new TerserPlugin({
         terserOptions: {
          compress: argv['optimize-minimize'] // only if -p or --optimize-minimize were passed
         }
       })
     ]
  };
};

```

- 第三种方法, 用defineplugin, 直接可以定义编译期的全局变量. js中可以直接使用.

###### 开发环境自动编译

- 有三种方式
  1. watch
  2. webpack-dev-server, 这个是在内存中编译. 并不生成文件. 
  3. `webpack-dev-middleware` 是一个封装器(wrapper)，它可以把 webpack 处理过的文件发送到一个 server。 `webpack-dev-server` 在内部使用了它.
- package.json的配置

```json
"scripts": {
    "test": "echo \"Error: no test specified\" && exit 1",
    "prod": "webpack --config webpack.prod.js",
    "dev": "webpack serve --config webpack.dev.js",
    "watch": "webpack --watch --config webpack.dev.js"
  },
```

- 参考样板项目, 生产和开发不同, web和node共存

###### 同时兼容node和web

- 使用target字段

```js
const path = require('path');
const serverConfig = {
  target: 'node',
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: 'lib.node.js'
  }
  //…
};

const clientConfig = {
  target: 'web', // <=== 默认为 'web'，可省略
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: 'lib.js'
  }
  //…
};

module.exports = [ serverConfig, clientConfig ];
//将会在 dist 文件夹下创建 lib.js 和 lib.node.js 文件
```

- target范围

```markdown
### https://webpack.js.org/configuration/target/
browserslist //#第一默认值
web //#第二默认值
//# 通过WebpackOptionsApply 支持
1. async-node
2. electron-main
3. electron-renderer //# 使用JsonpTemplatePlugin
```

- 注意如果在web中调用fs这样的库, webpack会报错.

###### 高德地图

- 用html插件配合template就OK了.
- https://github.com/jantimon/html-webpack-plugin   可以生成一个html, 并且可以使用template

```js
const webpackconfigjs={
plugins: [
		new CleanWebpackPlugin(),
		new HtmlWebpackPlugin(
			{
				template: 'src/index.html' //必须指定模板才可以. 
			}
		), //默认模板src/index.html不生效, 默认输出index.html

	],
	module: {
    rules: [
      {
        test: /\.html$/, //这个会和htmlplugin冲突, 因为他抢先处理并生成了目标html.
        loader: 'html-loader'
      }],
  },
}
//解决一: loader忽略模板html, 
{
    test: /\.html$/,
    exclude: [/node_modules/, require.resolve('./index.html')],
    use: {
        loader: 'file-loader',
        query: {
            name: '[name].[ext]'
        },
    },
},
//解决二: 不用loader, 解决三: 简单的把html重命名为ejs, 虽然ejs是个挺复杂的玩意, 但是, 幸好咱们不必学他. 
```

- https://stackoverflow.com/questions/43494794/webpack-html-webpack-plugin-error-child-compilation-failed

### blog

###### markdown转化为html

- 估计也是插件解决

###### webpack多个html: 

- https://github.com/ampedandwired/html-webpack-plugin#generating-multiple-html-files
- https://stackoverflow.com/questions/39798095/multiple-html-files-using-webpack
- static-site-generator-webpack-plugin

### 打包成为库

- 可以指定umd打包方案

```coffeescript
output:
		path: path.resolve(__dirname, 'dist/api')
		filename: '[name].js'
		library: 'webpackNumbers' # 指定library的name
    libraryTarget: 'umd', # 指定library编译的兼容性, common, es6, amd, umd, link...
```

- 官方建议使用一个index索引脚本作为entry, 不建议使用数组entry

```coffeescript
export {default as color} from './src/color.cs'
export {default as random} from 	'./src/random.cs'
export {default as Comp1} from 	'./src/random.test.cs'
export {default as time} from 	'./src/time.cs'
# 参考: https://stackoverflow.com/questions/34072598/es6-exporting-importing-in-index-file
```

###### 排除node_module的依赖, 不要把他们打包进来

```sh
yarn add --dev webpack-node-externals #这个很有用, 排除所有node_modules
```

- webpack.config.js的写法

```coffeescript
# 头部引入声明
nodeExternals = require('webpack-node-externals')
# export的external部分
externals:[ # 把lodash声明为外部的环境依赖, 这样运行库的时候回进行环境监测, 并且也避免把bodash打包到库里面.
		lodash:
			commonjs: 'lodash'
			commonjs2: 'lodash'
			amd: 'lodash'
			root: '_'
		react: 'react'
		subtract: ['./math', 'subtract']
		nodeExternals() #这个很有用, 排除所有node_modules
		/^library\/.+$/
	]
```

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
entry:
  glob.sync('./src/**.cs').reduce (obj, el)->
    obj[path.parse(el).name] = el
    obj
  ,{}
```

###### resolve可以让路径更合理

- 设置resolve可以让路径合理, 不至于lib路径稍微调整一下, 整体路径就有很大调整 

```coffeescript
# 参考: https://webpack.js.org/configuration/resolve/
# 配置
resolve: {
    alias: {
      xyz: path.resolve(__dirname, './path/to/'),
    },
  },
# js写法
import Test1 from 'xyz'; # 匹配 ./path/to/index.js 
import Test2 from 'xyz/file.js';  # 匹配 ./path/to/file.js 
# 特别注意
1. $xxx
xyz$: path.resolve(__dirname, './path/to/')
import Test1 from 'xyz'; # 匹配 ./path/to/index.js 
import Test2 from 'xyz/file.js';  # 匹配到 ./node_module/path/to/file.js
2. 'path/to' #非绝对(/开头)和相对路径(./或者../开头)
xyz: path.resolve(__dirname, 'path/to/')
import Test1 from 'xyz'; # 匹配到node_module
import Test2 from 'xyz/file.js';  # 匹配到node_module
3. file # 可以直接匹配到文件
xyz: path.resolve(__dirname, 'path/to/file.js')
# 此时如果没有$, 那么引入xyz/xxx.js会报错, 
# 如果有$, 那么引入xxx.js会匹配到node_module
4. index.js # 可以在package.json中指定
```

- 如果使用coffee

```coffeescript
resolve: extensions: ['.wasm', '.mjs', '.js', '.json'] # 规定了扩展名的解析顺序
resolve: #例如这样, 系统就自动去解析./src/index.cs了.
		alias: mlib: path.resolve(__dirname, './src/')
		extensions: ['.cs', '.coffee', '.mjs', '.js']
```

- 如果默认入口不是index.
  - 据说在package.json中设置main/module可以解决问题, 实际上并没有, 相对路径/绝对路径, 带扩展名/不带扩展名, 都尝试了, 并没有成功.
  - 目前没有成功. 但是, 这个需求并不急迫. 暂时放弃了. 

```coffeescript
	"main":"./src/in.cs"	, #这两行放到package.json, 没用
	"module": "./src/in.cs",
```

- 实际项目使用中

```coffeescript
# webpackconfig中 用resolve可以解决
resolve: # 解决自动查找index.cs而不是index.js的问题
  alias: mlib: path.resolve(__dirname, './src/mlib/src/')
  extensions: ['.cs', '.coffee', '.mjs', '.js']
```

###### coffee运行时可能报module错误

- 参考文档: module一劳永逸, coffee的一切, webpack和coffee
- 可能会引用不到, 经过尝试, 发现是webpack的配置文件编译为js的问题, 删除就好了, 也就是说, 之前设置的resolve没有生效. 看这个表现很可能是打包工具的bug, 下次出现记得删除就好.

```sh
modified:   webpack.common.coffee
deleted:    webpack.common.js
deleted:    webpack.common.js.map
```

### 插件打包

###### 插件打包i18n

###### 插件打包 多浏览器

###### 插件打包 后台文件合并并且引入配置文件

- 类似HtmlWebpackPlugin插件这样的, 针对manifest.json的插件. 
- 或许json插件就可以.  是的, 自动生成这个json.

###### 插件打包

- 考虑使用脚手架

### 配置文件

- 最好都是独立的. 比如babel和postcss

## 测试框架

- 需要在文件打包时做手脚, 
- 把我们的测试文件生成为可以运行的js文件.

### loader

### plugin



### 脚手架

- 我的项目都用了啥?
- map项目 done
  - babel
  - 自定义组件
  - 不同环境配置, 打包, git控制
- post项目
  - sass post项目要用
  - markdown/我自己的修改格式版本
  - github pages
  - static-site-generator-webpack-plugin
- 插件项目
  - i18n
  - 多浏览器插件
  - 性能优化, 依赖打包