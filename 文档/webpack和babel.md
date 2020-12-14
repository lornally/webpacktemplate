### 方法一用plugin: @babel/plugin-transform-runtime

###### 必须安装

```sh
yarn add --dev @babel/core @babel/preset-env @babel/preset-react @babel/plugin-transform-runtime  babel-loader 
yarn add  @babel/runtime
```

###### webpack.config.js配置

```js
{
  module: {
    rules: [ 
     {
				test: /\.m?js$/,
				exclude: /(node_modules|bower_components)/,
				use: {
					loader: 'babel-loader',
					options: {//特别注意presets: [[这里两个中括号
						presets: [['@babel/preset-env',{ 
							targets: {
								//"browsers": "chrome >= 86",
								"chrome": "86",
								"node": "15"
							} 
						}]],
						plugins: ['@babel/plugin-transform-runtime','@babel/plugin-proposal-object-rest-spread']					}
				}
			},
    ]
  }
}
```



### 方法二: 

- 配置babelrc的方式是更合理的方式, 注意这里是babel的配置示例, 不是webpack的.

```js
"presets": [
  [
    "@babel/preset-env",
    {
      "useBuiltIns": "usage", // alternative mode: "entry"
      "corejs": 3, // default would be 2
      "targets": "> 0.25%, not dead" 
      // set your own target environment here (see Browserslist)
    }
  ]
]
```

- 需要安装

```sh
npm i --save regenerator-runtime core-js
```



### 设置preset-env

- 参见前面的配置示例. 
- 这个如果都设置很高的标准, 会导致babel编译的时候使用很新的属性, 比如await/async不再转化为老式的回调函数.

###### 最好是配置一个babel的配置文件 

```json
.babelrc文件

{
  "presets": [
    ["es2015", { "modules": false }] //告诉babel不要解析模块.
  ]
}
```

