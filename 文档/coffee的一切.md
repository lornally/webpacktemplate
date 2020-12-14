###### 有以下几个地方

- post/2020-11-20coffee很简洁可以更简洁
- 样板项目/webpack和coffee
- 打包文档
  - module一劳永逸
  - webpack精华
  - ...
- oh-my-project/下一代的js
- 参考代码: 样板项目
  - lib
  - coffee
  - reactNamap

###### 调试

- 一定要开watch

```coffeescript
# package.json设置: 
"scripts": {
  "test": "echo \"Error: no test specified\" && exit 1",
  "prod": "webpack --config webpack.prod.js",
  "dev": "webpack serve --config webpack.dev.js", 
  "watch": "webpack --watch --config webpack.dev.js"# 可以是简明的 webpack --watch, 不一定要指定配置config文件
},
```
- 直接使用vscode的调试功能

```json
//launch.json
{
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
- 但是对于coffee的lib而言, vscode自动调试+webpackwatch会不生效

```coffeescript
#filename: '[name].[contenthash].js' # 这个会导致vscode的调试不生效. 好神奇.
filename: '[name].js' # 这个就没有问题了.
```
- 自动回归测试 todo 待研究