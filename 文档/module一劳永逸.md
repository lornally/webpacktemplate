> module一直是个问题, 不论是node端还是browser端. 是时候做个了结了. 本文档被引用的文件名: module一劳永逸

###### node的残缺方案

```json
{	"type": "module"}
```

- package.json加入上面这句

```sh
node --experimental-json-modules deal.js
```

- 运行时, 用这一句, 注意这句放到package.json里面作为script是不可以正常运行的. 

```js
//这句不支持
import {point as xian} from './xian500.json';
//这句OK
import  hangzhou from './hangzhou3000.json';
```

###### browser的残缺方案

- 比node方案还残废, 用起来贼搓. 就不多描述了.
- 有兴趣去看mdn, 但是, 这个的实际可用性真的为0.

###### webpack方案

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
    path: path.resolve(__dirname, 'dist'),
    filename: 'lib.node.js'
  }
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

###### babel方案

```sh
npm i -D babel babel-cli babel-core babel-preset-es2015
```

```js
//.babelrc文件
{"presets": ["es2015"]}
//package.json文件
"dev": "babel src -d dist && node dist/your_file.js"
```

- babel和webpack共存时, module最好有webpack负责, 因此babel配置

```js
//.babelrc文件

{
  "presets": [
    ["es2015", { "modules": false }] //告诉babel不要解析模块.
  ]
}
```



###### coffee方案

- coffee中使用了module, 运行时, 可能会报错.

```sh
To load an ES module, set "type": "module" in the package.json or use the .mjs extension.
SyntaxError: Cannot use import statement outside a module
```

- 命令行提示和so都说设置package.json

```coffeescript
"type": "module", # 亲测没用
```

- 直接使用vscode的bebug功能, launch.json, 参考webpack和coffee

