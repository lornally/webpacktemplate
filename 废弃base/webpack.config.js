const path=require('path');
const {CleanWebpackPlugin}=require('clean-webpack-plugin');
const toml=require('toml');
const yaml=require('yamljs');
const json5=require('json5');
const HtmlWebpackPlugin=require('html-webpack-plugin');
const Manifest=require('webpack-manifest-plugin');

module.exports={
	mode: 'development', //这个设置决定了是否压缩html等等.
	devtool: 'inline-source-map',
	devServer: {
		contentBase: './dist',
	},

	entry: {
		index: {import: './src/index.js',dependOn: 'shared'},
		another: {import: './src/another-module.js',dependOn: 'shared'},
		shared: 'lodash',
		//	sty: './src/style.css'
	},
	plugins: [
		new CleanWebpackPlugin({cleanStaleWebpackAssets: false}), //这样就不会清除index.html

		new HtmlWebpackPlugin({
		//	hash: true, //生成的文件名会有hash来对抗缓存.
			//minify: { 这个已经是默认的了, 不需要了. 主要是mode设置
			//	removeComments: true, //去除注释
			//	collapseWhitespace: true //去除不必要的空格
			//},
		}),
		//	new Manifest({}),


	],
	output: {
		filename: '[name].[contenthash].js',
		path: path.resolve(__dirname,'dist'),
		publicPath: '/',

	},

	optimization: {
		//moduleIds: 'deterministic', //这个可以, 没有这个也可以. 因为webpack5默认是这个.  
		//把node_modules单独打包, 单独缓存, 因为他们变化会比较少
		splitChunks: {
			//chunks: 'all',
			cacheGroups: {
				vendor: {
					test: /[\\/]node_modules[\\/]/,
					name: 'vendors',
					chunks: 'all',
				},
			},
		},
		runtimeChunk: 'single',

	},



	module: {
		rules: [
			{
				test: /\.m?js$/,
				exclude: /(node_modules|bower_components)/,
				use: {
					loader: 'babel-loader',
					//这些配置移到babelrc更合理
					//options: {//特别注意presets: [[这里两个中括号
					//	presets: [['@babel/preset-env',{ 
					//		targets: {
					//			//"browsers": "chrome >= 86",
					//			"chrome": "86",
					//			"node": "15"
					//		} 
					//	}]],
					//	plugins: ['@babel/plugin-transform-runtime','@babel/plugin-proposal-object-rest-spread']					}
				}
			},
			{
				test: /\.css$/,
				exclude: /(node_modules|bower_components)/,

				use: [
					'style-loader',
					'css-loader',
				],
			},
			{
				test: /\.(png|svg|jpg|gif)$/,
				exclude: /(node_modules|bower_components)/,

				use: [
					'file-loader',
				],
			},
		
			{
				test: /\.(csv|tsv)$/,
				exclude: /(node_modules|bower_components)/,

				use: [
					'csv-loader',
				],
			},
			{
				test: /\.xml$/,
				exclude: /(node_modules|bower_components)/,

				use: [
					'xml-loader',
				],
			},
			{
				test: /\.toml$/,
				exclude: /(node_modules|bower_components)/,

				type: 'json',
				parser: {
					parse: toml.parse
				}
			},
			{
				test: /\.yaml$/,
				exclude: /(node_modules|bower_components)/,

				type: 'json',
				parser: {
					parse: yaml.parse
				}
			},
			{
				test: /\.json5$/,
				exclude: /(node_modules|bower_components)/,

				type: 'json',
				parser: {
					parse: json5.parse
				}
			}
		],
	},
};
