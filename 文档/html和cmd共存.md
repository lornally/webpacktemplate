###### 参考项目

- 多个html命令行Nc24nNi18n

###### 整体结构

- webpack.base.coffee, 基础设置
- webpack.html.coffee, merge了基础设置, 并且加上了html的单独设置, 主要是output
- webpack.cmd.coffee, merge了基础设置, 并且加上cmd单独设置, 注意output和上面不能重复
- webpack.dev.coffee, 开发的配置, 同时输出html和cmd
- webpack.prod.coffee, 生产的配置, 应该只有html server的设置. (一般情况下)

###### 问题

1. cleanwebpackplugin会有问题, 因为多个项目公用的base文件如果引入这个, 那么后执行的配置就会删除前面配置的输出, 使用命令行删除目录, 可以解决这个问题

```sh
rm -rf
# package.json
"make": "rm -rf exroot/dist && webpack --config webpack.dev.coffee && chmod u+x ./exroot/dist/bin.js",
```

2. optimization:    runtimeChunk: 'single', 这个也会有问题, runtime.js会互相覆盖, 注释掉他就可以解决问题.
3. 其实这两个问题都是因为共用了输出目录, 这个错了, 应该用不同的输出目录.
4. 因此, cmd/html分别target:node和devserver