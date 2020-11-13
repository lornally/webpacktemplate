

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
