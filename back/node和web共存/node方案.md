项目目标: 

1. 彻底解决module问题
   1. 文档: module一劳永逸
2. 导出为lib
3. 一个回归测试框架
   1. 测试的价值在于回归测试. 
   2. mrtest测试包lib.

###### node的package方案

> 参考: 打包文档/module一劳永逸

- 安装内容

```sh
yarn add --dev @babel/core @babel/preset-env @babel/preset-react @babel/plugin-transform-runtime  babel-loader webpack  webpack-cli  clean-webpack-plugin  eslint-plugin-react coffeescript coffee-loader cson
```

- package.json
  - 去掉package.json中的type: module
  - 安装webpack以及devserver
- webpack.config.js中设置node相关内容.

```js
const path = require('path');
const serverConfig = {
	mode: 'development',
	devtool: 'inline-source-map',
	target: 'node',
  output: {
    path: path.resolve(__dirname, 'dist/api'),
    filename: 'api.js'
	},
	module: {
		rules: [
			{
				test: /\.m?js$/,
				exclude: /(node_modules|bower_components)/,
				use: {
					loader: 'babel-loader',			
				}
			},	
		],
	},
};

const clientConfig = {
  	devServer: {
		contentBase: './dist',
	},
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: 'lib.js'
  }
};

module.exports = [ serverConfig, clientConfig ];
```

- 因为使用了默认的src/index.js, 所以没有设置输入点.
- 调试时直接node执行就可以了. 

```sh
node lib.node.js
```

- babel配置

```js
//.babelrc文件, 不要处理module
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

