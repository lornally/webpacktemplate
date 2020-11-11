const HtmlWebpackPlugin=require('html-webpack-plugin');
const {CleanWebpackPlugin}=require('clean-webpack-plugin');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');


// This library allows us to combine paths easily
const path=require('path');
module.exports={
	entry: {
		app: './src/index.js',
		sty: './src/style.css',
	},

	output: {
		path: path.resolve(__dirname,'output'),
		filename: '[name].[contenthash].js',
	},

	plugins: [
		new CleanWebpackPlugin(),
		new HtmlWebpackPlugin({
			hash: true,
			favicon: './favicon.ico',
		}),
		new MiniCssExtractPlugin(),
	],
	module: {
		rules: [
		
			{
				test: /\.css/,
				use: [
					MiniCssExtractPlugin.loader, // instead of style-loader
					'css-loader',
				] 
			}
		]
	},
	

};
