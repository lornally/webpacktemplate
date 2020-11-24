###### 项目内容

- react
- 高德地图
- sass
- coffee
- css module

###### 页面中可以添加react

> https://zh-hans.reactjs.org/docs/add-react-to-a-website.html

###### coffee和react的关系

```coffeescript
{
  test: /\.coffee$|\.cs$/,
  exclude: /(node_modules|bower_components)/
  loader: 'coffee-loader'
  options: transpile: presets: ['@babel/env',"@babel/preset-react"]
}
```

###### balel

- .babelrc其实没有生效, 尝试使用babel.config.json
- 其实不是, coffee的babel配置是必须的. 不能省.
- babel自己的配置也不能省, 官方推荐使用babel.config.json, 不推荐.babelrc, 因为各种原因. 官方有说明: https://babeljs.io/docs/en/config-files#project-wide-configuration

```json
//这个文件是json5
{
  "presets": [
    "@babel/preset-react",
    ["@babel/preset-env", {
      "targets": {
        //"browsers": "chrome >= 86",
        "chrome": "86",
        "node": "15"
      },
      //告诉babel不要解析模块. 因为webpack会解析
      "modules": false
    }]
  ],
  "plugins": ["@babel/plugin-transform-runtime", "@babel/plugin-proposal-object-rest-spread"]
}
```

###### css-module

- 和react果然是绝配, 轻而易举的就实现了.

###### 坑

- 高德很傻, id必须是container, 换id就没显示.
- ejs是模板文件,  在webpack serve的过程中, 更改ejs并不触发更新
- 莫名其妙, 自动不起作用. 重启一下试试. todo