const path = require('path');
const serverConfig = {
	mode: 'development',
	devtool: 'inline-source-map',
	target: 'node',
	devServer: {
		contentBase: './dist',
	},

  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: 'lib.node.js'
  }
};

const clientConfig = {
	entry: {
    d1: './src/d1.js',
    d2: './src/d2.js'
  },

  output: {
    path: path.resolve(__dirname, 'dist'),
		filename: '[name].[contenthash].js',
  }
};

module.exports = [ serverConfig, clientConfig ];

