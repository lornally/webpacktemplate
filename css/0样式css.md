

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



