

> 因为全面拥抱coffee, 所以后续用coffee那个作为base



- webpack-manifest-plugin 有兼容问题, 这是一个指定输入输出对应关系的插件, 可以避免使用.

  - 即便从git下载最新版也不行. 

  ```sh
  #从git下载最新版
  yarn add 'ssh://git@github.com:shellscape/webpack-manifest-plugin.git'
  ```


- babel 需要处理await/async, 参见文档 webpack和babel

