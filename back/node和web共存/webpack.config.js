(function() {
  var CleanWebpackPlugin, HtmlWebpackPlugin, cmd, path, web;

  path = require('path');

  HtmlWebpackPlugin = require('html-webpack-plugin');

  ({CleanWebpackPlugin} = require('clean-webpack-plugin'));

  cmd = {
    mode: 'development',
    devtool: 'inline-source-map',
    target: 'node',
    output: {
      path: path.resolve(__dirname, 'dist/cmd'),
      filename: 'lib.node.js'
    }
  };

  web = {
    mode: 'development',
    devtool: 'inline-source-map',
    entry: {
      d1: './src/d1.js',
      d2: './src/d2.js'
    },
    output: {
      path: path.resolve(__dirname, 'dist/web'),
      filename: '[name].[contenthash].js'
    },
    plugins: [
      new CleanWebpackPlugin({
        cleanStaleWebpackAssets: false
      }),
      new HtmlWebpackPlugin({
        title: 'Development'
      })
    ],
    devServer: {
      contentBase: './dist/web'
    }
  };

  module.exports = [web, cmd];

  //module.exports = [ cmd, web ]

}).call(this);


//# sourceMappingURL=webpack.config.js.map
//# sourceURL=coffeescript