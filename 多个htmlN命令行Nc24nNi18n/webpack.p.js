(function() {
  // 为了解决webpack serve问题临时的config
  var HtmlWebpackPlugin, MiniCssExtractPlugin, base, merge, path, web;

  path = require('path');

  ({merge} = require('webpack-merge'));

  base = require('./webpack.base.coffee');

  web = require('./webpack.web.coffee');

  HtmlWebpackPlugin = require('html-webpack-plugin');

  MiniCssExtractPlugin = require('mini-css-extract-plugin');

  module.exports = merge(web, {
    mode: 'development',
    devtool: 'inline-source-map'
  });

}).call(this);


//# sourceMappingURL=webpack.p.js.map
//# sourceURL=coffeescript