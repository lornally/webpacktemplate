###### 项目内容

- react
- 高德地图
- sass
- coffee
- css module

###### 高德地图

- 使用最原始方式添加, 因为这货太坑了. 

###### 页面中可以添加react

> https://zh-hans.reactjs.org/docs/add-react-to-a-website.html

###### coffee和react的关系

```coffeescript
{
  test: /\.coffee$|\.cs$/,
  exclude: /(node_modules|bower_components)/
  loader: 'coffee-loader'
  options: transpile: presets: ['@babel/env',"@babel/preset-react"]
  #这一行的babel配置是必须的.
}
```

###### balel

- coffee的babel配置是必须的. 不能省.
- babel自己的配置也不能省, 官方推荐使用babel.config.json, 不推荐.babelrc, 因为各种原因. 官方有说明: https://babeljs.io/docs/en/config-files#project-wide-configuration

```json
//这个文件是json5
{
  "presets": [ //presets里面的项目的名字中的preset可以省略, 如下所示
    "@babel/preset-react", //这么也可以: "@babel/react",
    ["@babel/preset-env", { //这样也可以: "@babel/env"
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

- 和react果然是绝配, 直接就成功了.

###### webpack

- resolve字段的作用是, import资源的时候可以忽略的扩展名.

###### 坑

- 高德很傻, id必须是container, 换id就没显示.
- target: node会导致webpack serve的自动不起作用. 

###### react语法

```jsx
//组件使用函数写法, 不要使用class写法
function Welcome(props) {
  return <h1>Hello, {props.name}</h1>;
}
```

- 时代在进步stata也可以用function写法了

```coffeescript
import style from  "./style.module.sass"
import React, { useState }  from 'react'
import ReactDOM from 'react-dom'
export Hello = (props) ->
	[count, setCount] = useState(0)
	<div className={style.moduleclass}>
		<h1>props hello hahaha oeuaoeu {props.name}</h1>
		<p>You clicked {count} times</p>
      <button onClick={ -> setCount count + 1}>
        Click me
      </button>
  </div>

ReactDOM.render	<Hello name="天才"/>,document.getElementById('reactcontainer')
```

- react的层次概念其实有点烦, 想想传递参数要一层层传递下去. 
- 牛啊, 即便不用hooks, 也可以functional的写react. 不过要用prototype而已. 语法上面比较唠叨, 语法糖还是需要的.