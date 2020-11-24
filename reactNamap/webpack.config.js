(function() {
  var CleanWebpackPlugin, HtmlWebpackPlugin, MiniCssExtractPlugin, path;

  path = require('path');

  ({CleanWebpackPlugin} = require('clean-webpack-plugin'));

  HtmlWebpackPlugin = require('html-webpack-plugin');

  MiniCssExtractPlugin = require('mini-css-extract-plugin');

  //先按照测试环境配置, 生产环境是不一样的.
  module.exports = {
    mode: 'development',
    devtool: 'inline-source-map',
    target: 'node',
    output: {
      path: path.resolve(__dirname, 'dist/api'),
      filename: '[name].js'
    },
    entry: {
      app: ['./src/index.cs', './src/style.sass']
    },
    plugins: [
      new CleanWebpackPlugin({
        cleanStaleWebpackAssets: false
      }),
      new HtmlWebpackPlugin({
        hash: true,
        avicon: './favicon.ico'
      }),
      new MiniCssExtractPlugin
    ],
    module: {
      rules: [
        {
          test: /\.m?js$/,
          exclude: /(node_modules|bower_components)/,
          use: {
            loader: 'babel-loader'
          }
        },
        {
          test: /\.coffee$|\.cs$/,
          exclude: /(node_modules|bower_components)/,
          loader: 'coffee-loader',
          options: {
            transpile: {
              presets: ['@babel/env',
        "@babel/preset-react"]
            }
          }
        },
        {
          test: /\.cson$/,
          use: {
            loader: 'cson-loader'
          }
        },
        {
          test: /\.((c|sa|sc)ss)$/i,
          exclude: /node_modules/,
          use: [
            MiniCssExtractPlugin.loader,
            {
              loader: 'css-loader',
              options: {
                // Run `postcss-loader` on each CSS `@import`, do not forget that `sass-loader` compile non CSS `@import`'s into a single file
                // If you need run `sass-loader` and `postcss-loader` on each CSS `@import` please set it to `2`
                importLoaders: 1,
                // Automatically enable css modules for files satisfying `/\.module\.\w+$/i` RegExp.
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
    }
  };

}).call(this);


//# sourceMappingURL=webpack.config.js.map
//# sourceURL=coffeescript