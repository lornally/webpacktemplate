const path=require('path');
const toml=require('toml');
const yaml=require('yamljs');
const json5=require('json5');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const { CleanWebpackPlugin } = require('clean-webpack-plugin');


module.exports={
	mode: 'development',
	devtool: 'inline-source-map',
	devServer: {
		contentBase: './dist',
	},

	entry: {
		app: './src/mini.js',
		print: './src/print.js',
	},
	plugins: [
		new CleanWebpackPlugin(),

		new HtmlWebpackPlugin({
			title: '管理缓存',
		}),
	],
	output: {
		//filename: '[name].bundle.js',
		filename: '[name].[contenthash].js',

		path: path.resolve(__dirname,'output/online'),
		publicPath: '/',
	},
	optimization: {
		runtimeChunk: 'single',
		moduleIds: 'deterministic',

		splitChunks: {
      cacheGroups: {
        vendor: {
          test: /[\\/]node_modules[\\/]/,
          name: 'vendors',
          chunks: 'all',
        },
      },
    },
  },
	module: {
		rules: [
			{
				test: /\.css$/,
				use: [
					'style-loader',
					'css-loader',
				],
			},
			{
				test: /\.(png|svg|jpg|gif)$/,
				use: [
					'file-loader',
				],
			},
			{
				test: /\.(woff|woff2|eot|ttf|otf)$/,
				use: [
					'file-loader',
				],
			},
			{
				test: /\.(csv|tsv)$/,
				use: [
					'csv-loader',
				],
			},
			{
				test: /\.xml$/,
				use: [
					'xml-loader',
				],
			},
			{
				test: /\.toml$/,
				type: 'json',
				parser: {
					parse: toml.parse
				}
			},
			{
				test: /\.yaml$/,
				type: 'json',
				parser: {
					parse: yaml.parse
				}
			},
			{
				test: /\.json5$/,
				type: 'json',
				parser: {
					parse: json5.parse
				}
			}

		],

	},
};
