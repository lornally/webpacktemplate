(function() {
  // html server配置文件
  var HtmlWebpackPlugin, MiniCssExtractPlugin, base, merge, path;

  path = require('path');

  ({merge} = require('webpack-merge'));

  base = require('./webpack.base.coffee');

  HtmlWebpackPlugin = require('html-webpack-plugin');

  MiniCssExtractPlugin = require('mini-css-extract-plugin');

  module.exports = merge(base, {
    module: {
      rules: [
        {
          test: /\.((c|sa|sc)ss)$/i,
          exclude: /node_modules/,
          use: [
            MiniCssExtractPlugin.loader,
            {
              loader: 'css-loader',
              options: {
                importLoaders: 1,
                modules: {
                  auto: true
                }
              }
            },
            'postcss-loader',
            'sass-loader'
          ]
        }
      ]
    },
    entry: {
      pop: ['./src/pop.js', './src/pop.sass'],
      a1: ['./src/a1.cs', './src/a1.sass'],
      b1: ['./src/b1.js', './src/b1.sass'],
      rei: ['./src/rei.cs', './src/rei.sass', './src/rei.module.sass']
    },
    output: {
      path: path.resolve(__dirname, 'exroot/web')
    },
    plugins: [
      new HtmlWebpackPlugin({
        hash: true,
        favicon: './favicon.ico',
        template: './src/pop.ejs', // relative path to the HTML files
        filename: 'pop.html', // output HTML files
        chunks: ['pop'] // respective JS files
      }),
      new HtmlWebpackPlugin({
        hash: true,
        favicon: './favicon.ico',
        template: './src/a1.ejs', // relative path to the HTML files
        filename: 'a1.html', // output HTML files
        chunks: ['a1'] // respective JS files
      }),
      new HtmlWebpackPlugin({
        hash: true,
        favicon: './favicon.ico',
        template: './src/b1.ejs', // relative path to the HTML files
        filename: 'b1.html', // output HTML files
        chunks: ['b1'] // respective JS files
      }),
      new HtmlWebpackPlugin({
        hash: true,
        favicon: './favicon.ico',
        template: './src/rei.ejs',
        filename: 'index.html',
        chunks: ['rei'],
        cache: false
      }),
      new MiniCssExtractPlugin
    ],
    devServer: {
      contentBase: './exroot/web',
      watchContentBase: true,
      port: 8080
    },
    resolve: {
      alias: {
        mlib: path.resolve(__dirname, '/Users/bergman/git/_X/code/lib/mcktools/src/indexweb.cs')
      }
    }
  });

}).call(this);


//# sourceMappingURL=webpack.html.js.map
//# sourceURL=coffeescript