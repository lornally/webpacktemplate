

- 生成css这件事
	- 主要还是entry配合mini-css-extract-plugin
	- 在package.json加入如下内容, 并没有什么用
```json
"sideEffects": [
    ".css"
 ]
```


- css module 也在这里试试吧. 
	- 实验成功. webpack可以自动搞定. 
	- 为了html和css module的配合尝试下postcss
	- 反思了一下, html配合css module其实是不太对劲的思路, 因为, module在哪里呢? html的引用很难画一个合适的范围. 
	- 可能可以直接用, 在项目中尝试下.
- sass

  - vscode要安装插件sass, 这个就是之前的sass-indent
  - 此时就可以选择文件类型为sass了. 
  - 然后eslint就自动正常了.
  - unknown word 问题是由于错误的loader引起的. 另外, 如果a文件没有被引用, 那么a文件就不会被编译进结果. 因此, 不必担心. 
- postcss

  - 好东西, css的预处理框架. 可以搭载各种插件.
  - 直接webpack配置post是一种办法, 但是, 最好是新建一个postcss.config.js
  - 看文档不仔细啊, 根本不需要posthtml 有个很好地例子.git@github.com:maltsev/css-modules-webpack-example.git
  - postcss虽然很好用, 但是module完全不必对他进行任何设置. 

```sh
yarn add --dev postcss-loader postcss-preset-env postcss
```

```js
//postcss的配置也独立出来, postcss.config.js
module.exports = {
  plugins: [ //把plugin放这里就OK了.
    'postcss-preset-env',
  ],
};
```

- html中使用css module, 最后回到了ejs这个方案.
  - 官方demo是ejs配合react: https://github.com/css-modules/webpack-demo
  - 可能似乎用scrpt标签就可以, 试一试. 依旧不可以, 放弃这个思路, 直接用react吧. 
  - 放弃这个思路改为react
- stylelint stylefmt
- 引入css的方法
```html
<link href="/media/example.css" rel="stylesheet">
<style>
  @import "mystyle.css";
  @import url("mystyle.css") screen and (orientation:landscape);
</style>

import 'bootstrap/css/bootstrap.css!';

import 'bootstrap/css/bootstrap.css!css';

import 'bootstrap/css/bootstrap.css!customCssLoader';

```

- 参考15年的, 后来webpack改为和amd一致的写法了.: https://60devs.com/differences-in-plugin-micro-syntax-between-various-es6-loaders.html