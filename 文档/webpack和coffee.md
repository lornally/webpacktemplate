###### 安装

```sh
yarn add --dev webpack  webpack-cli webpack-merge webpack-dev-server webpack-dev-middleware webpack-manifest-plugin webpack-nano clean-webpack-plugin html-webpack-plugin mini-css-extract-plugin eslint-plugin-react coffeescript coffee-loader cson @babel/core @babel/preset-env @babel/preset-react @babel/plugin-transform-runtime  babel-loader 
```

###### 配置

- 可以用coffee配置webpack. https://webpack.docschina.org/configuration/configuration-languages/
- 此时会出现问题, 自动生成.js配置文件. 这些要删除, 参见webpack精华

```sh
modified:   webpack.common.coffee
deleted:    webpack.common.js
deleted:    webpack.common.js.map
```

###### react

```js
@babel/plugin-transform-react-jsx
//如果使用react, 那么需要这个plugin
 @babel/preset-react //这个preset包含了上面那个plugin
```

###### js2coffee

- 这个基本不能用不要装. http://js2.coffee/

```sh
npm install --global js2coffee
# The command line utility accepts both filenames or stdin.
js2coffee file.js [file2.js ...]
cat file.js | js2coffee
```

###### coffeelint

- 这个有用的. 基于eslint, http://www.coffeelint.org/#usage

```sh
npm install -g coffeelint
coffeelint --makeconfig > coffeelint.json #生成配置文件, 可以修改.
yarn add --dev eslint-plugin-coffee #eslint 自己也有.
#注意: 这玩意很傻, 先执行生成配置文件, 这个配置文件才生效.
```

```js
//需要修改eslintrc.js
{
  "parser": "eslint-plugin-coffee",
  "plugins": ["coffee"]
}
```

###### 用coffee作为webpack的配置文件

```sh
#安装过coffee就可以
yarn add --dev coffeescript #前面已经安装过了.
```

- 甚至于可以用jsx作为配置, jsx等价于json. (处理某个事物的工具, 等于那个事物. json=js)

###### 使用coffee

- https://github.com/jashkenas/coffeescript/wiki

###### react

- 完全不需要配置, 只要需要使用的js里面import就好了.

###### 运行

```sh
coffee example.coffee
#但是各种问题, 比如import不支持, cson不支持import...
#最终还是webpack解决一切问题.
# 如果使用了import module, 那么可能报错, 参考: module一劳永逸
```

- https://stackoverflow.com/questions/4679782/can-i-use-coffeescript-instead-of-js-for-node-js

###### 调试debug

由于运行依赖webpack, 所以调试coffee就没戏了, 目前是直接调试js. 按道理而言, 既然有sourcemap, 那么应该是可以调试的. 没有找到办法. 

```sh
# 至少https://github.com/node-inspector/node-inspector是可以的
npm install -g node-inspector
coffee -c -m *.coffee
node-debug app.js
# 他的替代版本: 
node --inspect index.js
# 官方说用这个, 其实也不灵.
coffee --nodejs debug server.coffee
```

- 是我傻叉了. 根目录进去直接就是可以debug coffee的. 奶奶的. 之前都是项目组, 所以不可以, 直接用项目根目录打开. 就可以直接debug了.
- 样板配置: https://github.com/Microsoft/vscode/issues/5963

```json
{ //大神给的
  "name": "Coffee",
  "type": "node",
  "request": "launch",
  "program": "${workspaceRoot}/coffee.coffee",
  "cwd": "${workspaceRoot}",
  "sourceMaps": true, //这个没必要, 本来默认就是true
  //下面三行是关键内容
  "stopOnEntry": true,
  "outFiles": [//"这里是webpack输出的js的地址",
    "${workspaceFolder}/**/*.js"
  ]
  "smartStep": false
}

{// 我自己的可以正常调试用的配置文件
  "version": "0.2.0",
  "configurations": [
    {
      "type": "node",
      "request": "launch",
      "name": "Launch Program",
      "skipFiles": [
        "<node_internals>/**"
      ],
      "program": "${file}", //这个好, 这个是当前文件
      "outFiles": [ //这个字段很关键, 没有这个就不能调试coffee, 这是说到哪里去搜索
        "${workspaceFolder}/dist/api/*.js"
      ]
    }
  ]
}
```

- 特别注意: 由于文件修改并不会触发编译, 因此很多时候调试会不对, 此时应该打开webpack watch