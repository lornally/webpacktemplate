> 开始阅读webpack文档

###### 20201102

1. 先弄一个实验性项目.
2. 打包我的map项目.   这个移动到map项目日志中. 
3. 我的blog继续使用pages, 但是抛弃Jekyll
4. 我的插件使用webpack打包, 在插件日志中

###### 第零步: 一个实验项目

- 项目目标:
  - gitignore分离不同的remote
  - webpack, 生产打包和测试打包不同. 
    - 测试打包针对测试server.
    - 生产打包所有内容都打到dist目录, 并且有单独的端口和地址配置. 
  - 兼容webpack cli 4
  - 使用pages, 不使用Jekyll, 文档和图片混排, 其实是说webpack能搞定静态页面吗? 不是单页应用的那种.
  - 解决我全局i18n问题吗?
  - 解决我多浏览器插件问题吗?
  - 解决插件js加载顺序问题吗? 所有需要的包, 不再global, 而是直接引入, 压缩.

实践

- gitignore 添加dist和output
- 兼容cli v4

```js
//配置文件: package.json
const v3={
  "scripts": {
    "build": "webpack -p",
    "dev": "webpack-dev-server --hot --inline",
  }};
//v4 默认product, 因此不必-p
const v4={
  "scripts": {
    "build": "webpack",
    "dev": "webpack serve",
  }};
```

```sh
#升级webpack-cli
yarn --dev upgrade  webpack-cli #这个木有用.
yarn --dev upgrade  webpack #依旧没用
#删除配置文件中的这行:
"webpack-cli": "^3.3.10",
#cli需要单独安装, 
```

- 生产和测试不同包. 
  - https://webpack.docschina.org/guides/production/
  - 按照指南一步一步来吧. 

指南

> https://webpack.docschina.org/guides/getting-started/

```sh
npm init -y  #注意此时目录不能有中文. 会报错
npm install webpack webpack-cli --save-dev

npm install --save lodash #这个是生产环境会用到的包
```

###### 1103

- 继续指南, webpack可以没有任何配置文件.

```sh
npx webpack
```

- 这条命令依赖于目录结构, 
  - src/index.js, 
  - dist/index.html, 
  - dist/main.js是输出
- webpack会处理import和export. 
- 如果需要编译新版本的js, 那么需要babel或者buble做为loader转义.
- webpack使用配置文件, 因为配置文件比命令行要简单很多. 

```sh
npx webpack --config webpack.config.js
```

- 这里的--config一串是没有意义的, 默认就是这个配置文件

```sh
npm run build
```

- 配置了package.json的script之后, 可以用这个命令行.

```sh
npm install --save-dev style-loader css-loader
```

- 引入css的loader也需要安装

```sh
npm install --save-dev file-loader
```

- 图片这样的文件的处理.
- 很智能, 有引用的图片才会被转化并且放置到dist目录.

```css
@font-face {
	font-family: 'MyFont';
	src:  url('./jmm.ttf') format('truetype'),url('./qdhg.ttf') format('truetype');
	font-weight: normal;
	font-style: normal;
}


.hello {
	color: white;
	font-size: 320px;
	font-family: 'MyFont';
}
```

###### 字体比较折腾: 

- 字体特殊的. ttf的格式是truetype, 这个没有成功, 暂时放弃.

```sh
yarn add font-awesome
```

- https://chriscourses.com/blog/loading-fonts-webpack

- 找到一个示例, 但是竟然需要xcode, 疯了.  是因为配置文件指定了webpack3.
- 但是依旧没啥用....
- https://icomoon.io/app/#/select/font
- 借助这个网站, 字体实验成功

```css
@font-face {
  font-family: 'icomoon';
  src:  url('./icomoon/fonts/icomoon.eot?2cg5rz');
  src:  url('./icomoon/fonts/icomoon.eot?2cg5rz#iefix') format('embedded-opentype'),
    url('./icomoon/fonts/icomoon.ttf?2cg5rz') format('truetype'),
    url('./icomoon/fonts/icomoon.woff?2cg5rz') format('woff'),
    url('./icomoon/fonts/icomoon.svg?2cg5rz#icomoon') format('svg');
  font-weight: normal;
  font-style: normal;
  font-display: block;
}
```

- html显示字符一般是这个格式: 

```html
&#xe97a;,&#xe97b; &#xe97c; &#xe97d; &#xe97e;&#xe97f; &#xe980;&#xe99b;&#xe99c;&#xe99d;&#xeaa7;
```

###### 1104

加载数据

```js
import Data from './data.json'
```

- json是默认支持的, 不需任何设置

```sh
npm install --save-dev csv-loader xml-loader
```

- csv和xml就需要loader支持了. 
- 可以把toml, yaml, json5作为json导入, 只要指定loader

```sh
npm install toml yamljs json5 --save-dev
```

- cool, webpack的思路是把资源结合起来, 可以按照事情来分组. cool, 这正是我想要的效果. 

管理输出

```sh
npm install --save-dev html-webpack-plugin
```

- 这个东东会自动生成入口index.html

```sh
npm install --save-dev clean-webpack-plugin
```

- 清理目标文件夹(dist)
- 问题出现了, 这货把git给删除了......

开发环境

```sh
npm install --save-dev webpack-dev-server #这一句报错
yarn add --dev webpack-dev-server #尝试这一句, 竟然就成功了.
```

- 这个就不需要每次都build了.
- 而且这个是真正的实时, 完全不需要刷新的. 自动就显示出来了. 

```sh
yarn add --dev express webpack-dev-middleware
```

- `webpack-dev-middleware` 是一个封装器(wrapper)，它可以把 webpack 处理过的文件发送到一个 server。 
- `webpack-dev-server` 在内部使用了它，然而它也可以作为一个单独的 package 来使用，以便根据需求进行更多自定义设置
- 用这种方式, 修改文件之后, 需要手动刷新浏览器. 

代码分离

- 这样可以异步加载.

```js
//动态导入
const { default: _ } = await import('lodash');
```

- 直接支持预获取prefetch和预加载preload
- bundle分析有很多工具. 

缓存

- 根据内容进行hash, 这样确保内容变化时, 刷新缓存

```js
const webpackconfigjs={
  output: {
    filename: '[name].[contenthash].js',
  },
  optimization: { 
    //把runtime独立出来, 不影响正常bundle的缓存
    runtimeChunk: 'single',
    moduleIds: 'deterministic', //这个可以, 没有这个也可以. 因为webpack5默认是这个.  
    moduleIds: 'hashed', //这个不能避免vendors的hash变化. 并且是废弃参数. 

    //把node_modules单独打包, 单独缓存, 因为他们变化会比较少
    splitChunks: {
      cacheGroups: {
        vendor: {
          test: /[\\/]node_modules[\\/]/,
          name: 'vendors',
          chunks: 'all',
        },
      },
    },
  },}
```

打包lib

- webpack擅长打包库. 
- 需要参考生产环境. 

###### 1105

- 继续看看文档. 

生产环境/测试环境/开发环境分离

```js
//一个独立的配置文件
if (process.env.NODE_ENV === 'development') {
  module.exports = `http://192.168.1.101:8000`
} else if (process.env.NODE_ENV === 'test') {
  module.exports = `http://192.168.1.102:8000`
} else {
  module.exports = `http://192.168.1.103:8000`
}
```

- 这个方式不优雅. 
- 查一下英文资料

```js
const webpackconfig={
	"plugins": [
		new webpack.DefinePlugin({ //建立编译的全局变量, 编译时会被替换进去
			ENV: process.ENV==='dev'? require('./dev-config-path'):require('./prod-config-path')
		})
	],
	plugins2: [
		new webpack.DefinePlugin({
			API: process.ENV==='dev'? 'localhost:3000':'xxx.xxx.x.x'
		}),
	],

	//配合这个, js用着还算方便.
	externals: {
		'Config': JSON.stringify(process.env.NODE_ENV==='production'? {
			serverUrl: "https://myserver.com"
		}:{
				serverUrl: "http://localhost:8090"
			})
	},

	externals2: {
		'Config': JSON.stringify(process.env.NODE_ENV === 'production' ? require('./config.prod.json') : require('./config.dev.json'))
	},

};

```

- js 可以这样使用配置文件

```js
var Config = require('Config')
fetchData(Config.serverUrl + '/Enterprises/...')

//react
import Config from 'Config';
axios.get(this.app_url, {
  'headers': Config.headers
}).then(...);
```

- react可以用env文件
  - https://stackoverflow.com/questions/30568796/how-to-store-configuration-file-and-read-it-using-react/30602665#30602665
- entry可以是html

```
entry: {
    javascript: "./js/app.js",
    html: "./index.html",
  },
```

- 也可以用插件copy: https://github.com/webpack-contrib/copy-webpack-plugin
- 可以用file-loader直接copy

```sh
npm install copy-webpack-plugin --save-dev
```

```
const CopyPlugin = require('copy-webpack-plugin');

module.exports = {
  plugins: [
    new CopyPlugin({
      patterns: [
        { from: 'source', to: 'dest' },
        { from: 'other', to: 'public' },
      ],
    }),
  ],
};
```

```js
module.exports = [
  {
    name: "client",
    target: "web",
    /* your client side configuration */
  },
  {
    name: "rendering",
    target: "node",
    entry: {
      "index.html": "./app/index.html",
    },
    output: {
      path: path.resolve("build")
      filename: "rendering/[name].js"
    }
  }
]
webpack && node -e "console.log(require('./build/render/index.html.js'))" > build/public/index.html
```

- https://github.com/jantimon/html-webpack-plugin   可以生成一个html, 并且可以使用template
- https://stackoverflow.com/questions/39798095/multiple-html-files-using-webpack

###### 1106

- 高德地图
  - 找插件的思路不合适, 因为基本上没有. 
  - 用html插件配合template就OK了.
- 他山之石google地图
  - 直接用html插件是王道.
  - 也有人写了兼容代码, 太缠绕了. 
- 脚手架
  - webpack, babel, sass
  - https://dev.to/stowball/creating-a-production-ready-eleventy-project-with-webpack-babel-and-sass-35ep
- 开始尝试打包map项目

###### 1107

- 开始弄map项目. 弄一个完全满足map需求的实验项目. 

###### 1109

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

- https://webpack.docschina.org/configuration/configuration-types/
- 配置文件的多种写法

```js
//导出单个配置
module.export={};
//导出函数
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
// todo 异步的pormise也是可以的, 目前没有需求, 待研究. 
//导出多个配置
module.exports = [{
  output: {
    filename: './dist-amd.js',
    libraryTarget: 'amd'
  },
  name: 'amd',
  entry: './app.js',
  mode: 'production',
}, {
  output: {
    filename: './dist-commonjs.js',
    libraryTarget: 'commonjs'
  },
  name: 'commonjs',
  entry: './app.js',
  mode: 'production',
}];
```



###### 1110

- webpack自动安装各种插件等等

###### 1111

- htmlplugin并没有插入title,     inject: true,是关键
- 输出css没有效果,  const MiniCssExtractPlugin = require('mini-css-extract-plugin');   用实验项目试一下. 还要配合entry, 整件事就OK了. 
- 事到如今, 有点糊涂了. 重来一遍基础

###### 1112

- 继续基础项目
- 明白了webpack会分析js和css的引用和调用情况, 只会copy真正需要的项目到目标文件夹.

###### 1113

- webpack-manifest-plugin 有兼容问题, 目前无解.  这是一个指定输入输出的插件. 

  - 即便从git下载最新版也不行. 

  ```sh
  #从git下载最新版
  yarn add 'ssh://git@github.com:shellscape/webpack-manifest-plugin.git'
  ```

- 生成css这件事, 在package.json加入如下内容, 并没有什么用

```json
"sideEffects": [
    ".css"
 ]
```

- css module done  先弄
- 然后, 继续webpack实践, 到了缓存, done, 止于创建库.
- sass和coffee这种好玩意, 以后用起来. todo.

###### 1114

- sass在线工具, p>翻译成什么? sass没错, 很精确. 继续使用.

###### 1115

- react和coffee都要搞.
- react是module的先决条件.
- 清理一下现有的页面, 就弄coffee吧. 
- 人家的案例是能用的 https://github.com/jantimon/html-webpack-plugin

```ejs
  <%= require('html-loader!./partial.html') %>

//src/index.ejs
  <%= require('html-loader!../partial.html') %>
//难道只有根目录才能被引用吗?
```

- 这里的叹号啥意思?
  - webpack的loader语法
  - htmlwebpackplugin的文档
  - 概念需要看完啊. 很重要. 

###### 1116

- 概念继续
- 一通尝试, 没啥效果, 继续webpack概念.
- 准备先弄coffee, 再弄react

###### 1117

- 凌晨3:06, 基本阅读完成. 

- 预计今天清空html.

- todo 用react的框架
  - create-react-app
    - 搞coffee
    - 搞css module
    - 搞控件
    - 搞库


###### 1227

- 开始尝试支持softlink

````coffeescript
# webpack.common.coffee
resolve: # 解决自动查找index.cs而不是index.js的问题 #lib的配置
alias: mlib: path.resolve __dirname, './src/mlib/src/'
extensions: ['.cs', '.coffee', '.mjs', '.js']
symlinks: true
# 这里明白了, 不该alias 再加symlink, 直接alias过去就好了.
# alias依旧不支持~
````

- 尝试成功, 遇到一个报错

```sh
Module not found: Error: Can't resolve '@babel/runtime/helpers/interopRequireDefault' in '/Users/bergman/git/_X/code/lib/mcktools/src'
# 这个报错的原因是mcktools项目本身没有安装自己以来的module, 并且也没有webpack build过. 他本身OK了. 整个项目也就OK了.
```

###### 20210115

- 多个html
- 官方文档就有多页面: https://github.com/jantimon/html-webpack-plugin#generating-multiple-html-files
- stackoverflow
  - https://stackoverflow.com/questions/52434167/how-can-i-use-multiple-entries-in-webpack-alongside-multiple-html-files-in-htmlw
  - https://stackoverflow.com/questions/39798095/multiple-html-files-using-webpack

###### 20210116

- 完成多html页面
- 尝试i18n
  - 不同的语言用不同的cson
  - 或者同一个cson, 不同的key

###### 20210118

- c24n coffeeinternathionalization



###### 0119

- 完成了c24n
- 完成了cmd和html共存

###### 0120

- 凌晨1:00, 困了, 睡醒了继续弄react配合c24n(i18n的coffee版本)
- 昨天的问题其实是输出目录的问题, html和cmd要分开 done
- 继续react

###### 0121

- 在react配合i18n的道路上遇到了.问题.
- webpack dev server 配合html-webpack-plugin结果不正常.
- show这个项目看一下是否能解决上面的问题, 但是编译不通过.
- 原因是mcktools没有分开cmd和html的编译, 导致引入的项目编译不通过.
- 因此, 需要先把mcktools的编译结果分开. 这个我熟练啊. 顺手把dev和prod也分开吧.
- 由此可见webpack项目基本要素:
  - dev和prod分开
  - html和cmd分开
  - 多html, 多js支持
  - react支持
  - c24n/i18n支持

1. mcktools的dev/prod分离, 以及html/cmd分离