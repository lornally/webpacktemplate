> webpack最重要的就是概念

###### 入口

```js
//单个入口
module.exports = {
  entry: './path/to/my/entry/file.js',
  
  //多个入口
  entry: {
    app: './src/app.js',
    adminApp: './src/adminApp.js'
  },
  //有基础入口的多个入口
  entry: {
    index: {import: './src/index.js',dependOn: 'shared'},
    another: {import: './src/another-module.js',dependOn: 'shared'},
    shared: 'lodash',
  },

  //多个文件组合为一个入口, 配合htmlwebpackplugin
  entry: {
    app: ['./src/index.js', 
          './src/style.sass',]
  }
}
```

- 不要给vendor配置入口, 可以通过[`optimization.splitChunks`](https://webpack.docschina.org/configuration/optimization/#optimizationsplitchunks)进行模块优化. 

###### 输出

```js
module.exports = {
  output: {
		filename: '[name].[contenthash].js',
		path: path.resolve(__dirname,'dist'),
		publicPath: '/', //这个如果不确定, 可以在入口文件设置
	},
};

//入口的js文件可以设置publicpath
__webpack_public_path__ = myRuntimePublicPath;
```

###### loader

```js
module.exports = {
  module: {
    rules: [
      {
        test: /\.((c|sa|sc)ss)$/i,
        exclude: /node_modules/,
        use: [
          MiniCssExtractPlugin.loader,
          {
            loader: 'css-loader',
            options: {
              importLoaders: 1,
              modules: {auto: true},
            },
          },
          'postcss-loader', //他有单独的配置文件postcss.config.js
          'sass-loader',
        ],
      },
      {
        test: /\.(png|jpe?g|gif|svg|eot|ttf|woff|woff2)$/i,
        loader: 'url-loader',
        options: {
          limit: 8192,
        },
      },
    ]
  },
}

//postcss.config.js
module.exports = {
  plugins: [
    ['postcss-preset-env',{stage: 0}],
  ],
};
```

- 内联方式, 简单的说就是在源文件中互相引用, 如果使用cssmodule, 这个似乎有用.

```js
//可以在 import 语句或任何 与 "import" 方法同等的引用方式 中指定 loader。使用 ! 将资源中的 loader 分开。每个部分都会相对于当前目录解析。
import Styles from 'style-loader!css-loader?modules!./styles.css';

//使用 ! 前缀，将禁用所有已配置的 normal loader(普通 loader)
import Styles from '!style-loader!css-loader?modules!./styles.css';
//使用 !! 前缀，将禁用所有已配置的 loader（preLoader, loader, postLoader）
import Styles from '!!style-loader!css-loader?modules!./styles.css';
//使用 -! 前缀，将禁用所有已配置的 preLoader 和 loader，但是不禁用 postLoaders
import Styles from '-!style-loader!css-loader?modules!./styles.css';

//选项可以传递查询参数，例如 ?key=value&foo=bar，或者一个 JSON 对象，例如 ?{"key":"value","foo":"bar"}。
```

- 命令行方式

```sh
webpack --module-bind pug-loader --module-bind 'css=style-loader!css-loader'
#这会对 .jade 文件使用 pug-loader，以及对 .css 文件使用 style-loader 和 css-loader。
```

###### plugin

- webpack自己也是插件

```js
const HtmlWebpackPlugin = require('html-webpack-plugin'); // 通过 npm 安装
const webpack = require('webpack'); // 访问内置的插件
const path = require('path');
module.exports = {
  output: {
    path: path.resolve(__dirname, 'dist')
  },
  plugins: [
    new webpack.ProgressPlugin(),
    new HtmlWebpackPlugin({template: './src/index.html'})
  ]
};
```

###### 配置

- commonjs, 所以使用require.
- 多个target, 导出一个数组, 这对于lib编写很有用.  
  - 这里并不是target属性, target属性可以指定导出web(可以指定浏览器版本), node, electron等等.
  - 这里的意思就是导出一个数组

```js
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

- 可以使用其他配置语言
  - ts
  - coffee
  - babel+jsx

###### 模块

- 范围
  - es6 import, commonJS require, AMD define/require
  - css/sass @import
  - stylelink url, img src
- 开箱支持
  - es6, commonJS, AMD
  - Assets 各种资源, 比如文件, base64的data uri
  - webAssembly 网络汇编语言
- loader支持
  - coffee
  - ts
  - esNext babel
  - sass
  - less
  - stylus
  - elm
  - ...

###### 模块解析 resolve

- 可以解析三种路径: 绝对, 相对, 模块路径

```js
//绝对
import '/home/me/file';
//相对
import '../src/file1';
import './file2';
//模块
import 'module';
import 'module/lib/file';
```

- webpack会分析找到的是文件还是文件夹
  - 如果是文件
    - 如果指定扩展名, 就匹配扩展名进行打包
    - 如果没指定扩展名, 就根据[`resolve.extensions`](https://webpack.docschina.org/configuration/resolve/#resolveextensions)查询是否有满足要求的扩展名, js, jsx, coffee...
  - 如果是文件夹, 要找到mainfile后, 根据[`resolve.extensions`](https://webpack.docschina.org/configuration/resolve/#resolveextensions)打包, 找mainfile有两种情况: 
    - 如果有package, 根据package.json确定文件路径.
    - 如果么有, 那么就顺序查找是否有合适的mainfile
- loader解析也是类似的, 不过[`resolveLoader`](https://webpack.docschina.org/configuration/resolve/#resolveloader)可以配置解析规则.
- 缓存
  - watch模式, 修改的文件才会清缓存.
  - 其他情况, 每次编译前都会清缓存.

###### 模块联合 federation

- 应用有模块组成, 模块可以单独开发, 互相不依赖.
- 底层概念
  - 本地模块
  - 远程模块, 异步加载
- chunk load操作就是一次import的调用.
- container entry 创建container, container进行了两个异步操作
  - module load
  - module 执行, 按照调用顺序执行.
- container
  - 可以嵌套
  - 可以使用其他container里面的module
  - 闭环依赖也是可以被支持的. 
- container可以标志local module可覆盖, 
  - (个人理解, 这就是开发时的本地代码的状态) , 
  - 覆盖发生在真实的调用执行之前, 一旦发生了一次调用, 那么本次执行就不再允许覆盖了. 
  - (个人理解, 这样可以降低watch或者dev-server的开销)
- 高层抽象
  - 每一个编译(build)动作都是一个container.
  - shared module 可以被嵌套的container重载(override)
  - 选项packagename可以自动推断版本, 如果禁用自动推断那么也要设置requiredversion为false.
- 案例use case
  - 单页应用, 
    - 每一页都是独立的build
    - 外壳也是一个独立的build, 并引用每一个单页应用为remote module.
  - 库程序
    - 库程序被build为container
  - 动态远程container
    - 可以使用异步函数init, 这个函数的参数是shared scope object.
    - 这样可以做动态a/b test.

###### 依赖图

- webpack从入口开始构建整个依赖.
- 一般会打包成一个依赖, 这样能节省下载速度.
- 也可以进行代码分割优化, 提升并行下载.

###### 编译目标target

```js
const path = require('path');
const serverConfig = {
  target: 'node',
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: 'lib.node.js'
  }
};

const clientConfig = {
  target: 'web', // <=== 默认为 'web'，可省略
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: 'lib.js'
  }
};

module.exports = [ serverConfig, clientConfig ];
```

- 此章节有关于electron的参考

###### manifest

- 项目有三类代码
  - 自己编写的本地代码
  - 库或者vendor代码
  - webpack的runtime和manifest
- runtime
  - 链接模块的代码. 
  - 延迟加载的逻辑.
- manifest
  - 保留了bundle和引用的资源之间的关系, 打包, 压缩, 延迟加载的chunk的描述. 
  - runtime根据menifest来解析和加载模块.
  - 不论是import还是require, 都变成了__webpack_require_方法, 这个方法依赖module identifier加载模块. runtime参考manifest的数据, 找到module identifier
- 如果使用浏览器缓存来改善性能, 那么需要理解这个. 很多时候, 内容没变, 但是 content hash变了, 这就是因为 runtime和manifest的变化引起的. 

###### 模块热替换 hot module replacement HMR

- (个人理解, 这个貌似就是dev-server背后的技术)
- 在开发环境中, HMR和liveReload互相替代

###### 为何选择webpack

- 闭包(IIFE) - Immediately invoked function expressions
  - 可以配合任务执行器, make, gulp, grunt, broccoli, brunch等
  - 很难判断代码是否被实际使用. 
  - 如果只用了lodash的一个函数, 也要引入整个包. 
  - 懒加载的实现也有难度. 需要开发人员手动实现.
- node.js引入了module, npm + node + module 
  - 没有浏览器支持.
  - 没有live binding, 动态绑定.
  - 循环引用会有问题(闭环引用).
  - 同步模块解析加载很慢.
  - browserify, requirejs, systemjs等工具.
- es module
  - 浏览器支持坑.
  - node支持也坑.
- 这些工具都缺少依赖自动收集机制.
  - 基于google的closure, 要求顶部声明所有依赖. 
- 原因
  - 可以编写module
  - 支持所有module格式
  - 可以处理js库资源, 也可以处理字体/图片/base64uri/style这样的asset
  - 提供性能和加载优化, 例如异步加载, 预加载, 懒加载....

###### 内部原理

- 主要构成
  - 每个文件都是一个module
  - 互相引用形成 modulegraph
  - 打包过程中, module合并为chunk.
  - chunk合并为chunk组时, chunk组内部形成modulegraph
  - 一个入口entry形成一个chunk组.
- chunk分两种
  - initial, 包含入口的module和他们的依赖.
  - non-initial, 懒加载的chunk, 动态导入或者拆分优化chunk时会出现. 
- chunk有自己对应的asset输出文件, (本来asset指图片, 字体, style, base64uri)

```js
//webpack.config.js
module.exports = {
  entry: './src/index.jsx' //chunk1  默认输出chunk: main.js
};
//.src/index.jsx
import React from 'react';//chunk2
import ReactDOM from 'react-dom';//chunk3

import('./app.jsx').then(App => ReactDOM.render(<App />, root)); //这一行已经是动态导入了, 所以会形成non-initial chunk
//默认non-initial chunk没有名字, 直接用id, 比如345.js

//但是, 可以用magic comment指定chunk名称.
import(
  /* webpackChunkName: "app" */ //这个就是magic comment
  './app.jsx'
).then(App => ReactDOM.render(<App />, root));
```

- 输出output
  - output.filename, initial chunk的文件名
  - output.chunkFilename  non-initial chunk的文件名.
  - 有一些占位符
    - [id] 
    - [name]
    - [contenthash]

