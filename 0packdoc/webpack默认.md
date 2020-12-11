###### 默认安装

```sh
cnpm install -g eslint 
cnpm install -g yarn

#webpack
yarn add --dev webpack  webpack-cli webpack-merge webpack-dev-server webpack-dev-middleware webpack-manifest-plugin webpack-nano clean-webpack-plugin html-webpack-plugin mini-css-extract-plugin eslint-plugin-react stylelint lint-staged 

# 排除所有的依赖的node_module
yarn add --dev webpack-node-externals
# 多个entry
yarn add --dev webpack-glob

#babel
yarn add --dev @babel/core @babel/preset-env @babel/plugin-transform-runtime  babel-loader 

#sass
yarn add --dev sass css-loader sass-loader style-loader 
#官方推荐dart sass(就是sass), 不推荐 node-sass

#postcss
yarn add --dev postcss-loader postcss-preset-env postcss ejs   
#本质上, 这个也是不需要的postcss-modules 
#文档看的太粗糙, 根本不需要这些 posthtml-postcss posthtml posthtml-css-modules

#coffee
yarn add --dev coffeescript coffee-loader cson cson-loader eslint-plugin-coffee

#react
yarn add --dev react react-dom eslint-plugin-react @babel/preset-react eslint-plugin-react-hooks


#数据文件
yarn add --dev csv-loader file-loader xml-loader autoprefixer  toml json5 yamljs 


yarn add lodash react react-dom @babel/runtime

#从git下载最新版
yarn add 'ssh://git@github.com:shellscape/webpack-manifest-plugin.git'
```

###### 默认package.json

```json
{
  "name": "show",
  "version": "1.0.0",
  "description": "数据的可视化展示",
  "main": "src/index.js",
  "repository": {
    "type": "git",
    "url": "git+https://github.com/lornally/tspshow.git"
  },
  "keywords": [
    "show",
    "map",
    "datashow"
  ],
  "author": "michael",
  "license": "ISC",
  "bugs": {
    "url": "https://github.com/lornally/tspshow/issues"
  },
  "homepage": "https://github.com/lornally/tspshow#readme",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1",
    //单配置
    "build": "webpack",
    "dev": "webpack serve",
    "watch":"webpack --watch",
    "server": "node server.js",
    //多配置, 比如prod和dev不同配置
    "build": "webpack --config webpack.prod.js",
    "dev": "webpack serve --config webpack.dev.js",
    "prod": "webpack serve --config webpack.prod.js",
    "watch": "webpack --watch --config webpack.dev.js"
  },
}
```

###### 默认webpack.config.js

- wepack.common.js

```js
//基础的webpack配置文件
const path=require('path');
const {CleanWebpackPlugin}=require('clean-webpack-plugin');
const HtmlWebpackPlugin=require('html-webpack-plugin');


module.exports={
  entry: {
    app: './src/index.js',
  },
  plugins: [
		new CleanWebpackPlugin(),
		new HtmlWebpackPlugin(),
    //默认模板src/index.ejs 默认输出index.html
    //如果使用html模板, 那么很容和loader冲突
	],
	module: {
    rules: [
      {
        test: /\.html$/,
        loader: 'html-loader'
      }],
  },
 
  output: {
    filename: '[name].[contenthash].js',
    //使用filename: '[name].[contenthash].js', 保证有更新就刷缓存. 
    path: path.resolve(__dirname,'output/online'),
    //这里output中的文件不会被自动清除, 所以可以设置为git控制的目录.
    publicPath: '/',
  },
  optimization: { 
    //把runtime独立出来, 不影响正常bundle的缓存
    runtimeChunk: 'single',
    moduleIds: 'deterministic', //这个可以, 没有这个也可以. 因为webpack5默认是这个.  
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
  },
};


```

- webpack.dev.js

```js
//开发用的webpack配置文件

const { merge } = require('webpack-merge');
const common = require('./webpack.common.js');

module.exports = merge(common, {
  mode: 'development',
  devtool: 'inline-source-map',
  devServer: {
    contentBase: './output/online',
	},
	externals: { //直接配置
		'Config': JSON.stringify({
			//本机的url
			apiurl: 'http://localhost:30004/wuliu_back/uds/'
		})
	},
});

```

- webpack.prod.js

```js
//生产环境用的配置文件
const {merge}=require('webpack-merge');
const common=require('./webpack.common.js');

module.exports=merge(common,{
	mode: 'production',
	externals: { //直接配置
		'Config': JSON.stringify({
			//server的url
			apiurl: 'http://39.100.155.145:30004/wuliu_back/uds/',
		})
	},
});

```

- 兼容node和web的写法

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

- lib的写法

###### 默认的相关配置

- .babelrc

```json
{
	"presets": [
		["@babel/preset-env", {
			"targets": {
				//"browsers": "chrome >= 86",
				"chrome": "86",
				"node": "15"
			},
			"modules": false //告诉babel不要解析模块.
		}]
	],
	"plugins": ["@babel/plugin-transform-runtime", "@babel/plugin-proposal-object-rest-spread"]
}

```

- postcss.config.js

```js
//postcss的配置也独立出来, postcss.config.js
module.exports = {
  plugins: [ //把plugin放这里就OK了.
    'postcss-preset-env',
  ],
};
```

