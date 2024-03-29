const HtmlWebpackPlugin=require('html-webpack-plugin');
const {CleanWebpackPlugin}=require('clean-webpack-plugin');
const MiniCssExtractPlugin=require('mini-css-extract-plugin');
//const postcssPresetEnv = require('postcss-preset-env');
//const posthtmlcssmodule=require('posthtml-css-module');
//const style =require(  "./src/style.module.sass");

// This library allows us to combine paths easily
const path=require('path');
module.exports={

	//mode: 'development',
	//devtool: 'inline-source-map',
	//devServer: {
	//	contentBase: './output',
	//},


	entry: {
		//app: './src/index.js', 
		//sty: './src/style.css', //这个写法虽然也可以, 但是生成了多余的.css.js文件.
		app: ['./src/index.js', //这个写法貌似是完美的写法.
			'./src/style.sass',]
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
			title: 'css 实验项目', //用了模板之后, 这个就失效了.
			templateParameters:{
				title: JSON.stringify({xxx:'toeuoe'}),
			},
	//		template: './src/index.html',
		}),
		//这里不设置filename, 也是正确结果. 
    new MiniCssExtractPlugin({ filename: '[name].[contenthash].css' })
	],
	module: {
		rules: [
			{
				// For pure CSS - /\.css$/i,
				// For Sass/SCSS - /\.((c|sa|sc)ss)$/i,
				// For Less - /\.((c|le)ss)$/i,
				test: /\.((c|sa|sc)ss)$/i,
				exclude: /node_modules/,
				use: [
					MiniCssExtractPlugin.loader, // instead of style-loader
					{
						loader: 'css-loader',
						options: {
							// Run `postcss-loader` on each CSS `@import`, do not forget that `sass-loader` compile non CSS `@import`'s into a single file
							// If you need run `sass-loader` and `postcss-loader` on each CSS `@import` please set it to `2`
							importLoaders: 1,
							// Automatically enable css modules for files satisfying `/\.module\.\w+$/i` RegExp.
							modules: {auto: true},
							//sideEffects: true, // 这一句并没有啥用.
						},
					},
				//	{
				//		loader: 'postcss-loader',
				////		options: {postcssOptions: {plugins: () => [postcssPresetEnv({stage: 0})]}},
				//	},
					//{
					//	loader: 'sass-loader',
					//},

					'postcss-loader',
					'sass-loader',

				],
			},
			{
				test: /\.(png|jpe?g|gif|svg|eot|ttf|woff|woff2)$/i,
				loader: 'url-loader',
				options: {
					limit: 8192,
				},
			},
			//{
			//	//	loaders: ['html?interpolate'],
			//	test: /\.html$/,
			//	loader: 'html-loader',
			
			//},
			//{
			//	test: /\.html$/,
			//	use: [
			//		'html-loader',
			//		{
			//			loader: 'posthtml-loader',
			//			options: {
			//				ident: 'posthtml',
			//				parser: 'PostHTML Parser',
			//				plugins: [
			//					/* PostHTML Plugins */
			//				//	posthtmlcssmodule
			//					require('posthtml-css-module')()
			//				]
			//			}
			//		}
			//	]
			//},

		]
	},
};
