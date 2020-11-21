(function() {
  var CleanWebpackPlugin, path;

  path = require('path');

  ({CleanWebpackPlugin} = require('clean-webpack-plugin'));

  //先按照测试环境配置, 生产环境是不一样的.
  module.exports = {
    mode: 'development',
    devtool: 'inline-source-map',
    target: 'node',
    output: {
      path: path.resolve(__dirname, 'dist/api'),
      filename: '[name].js'
    },
    entry: './src/index.cs',
    plugins: [
      new CleanWebpackPlugin({
        cleanStaleWebpackAssets: false
      })
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
          loader: 'coffee-loader',
          options: {
            transpile: {
              presets: ['@babel/env']
            }
          }
        },
        {
          test: /\.cson$/,
          use: {
            loader: 'cson-loader'
          }
        }
      ]
    }
  };

  
//HtmlWebpackPlugin = require('html-webpack-plugin')
//webpack = require('webpack')
//path = require('path')

//config =
//	mode: 'production'
//	entry: './path/to/my/entry/file.js'
//	output:
//			path: path.resolve(__dirname, 'dist')
//			filename: 'my-first-webpack.bundle.js'
//	module: rules: [ {
//		test: /\.(js|jsx)$/
//		use: 'babel-loader'
//	} ]
//	plugins: [
//		new HtmlWebpackPlugin(template: './src/index.html')
//	]

//module.exports = config

}).call(this);


//# sourceMappingURL=webpack.config.js.map
//# sourceURL=coffeescript