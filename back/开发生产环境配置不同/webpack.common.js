//基础的webpack配置文件
const path=require('path');
const {CleanWebpackPlugin}=require('clean-webpack-plugin');
const HtmlWebpackPlugin=require('html-webpack-plugin');


module.exports={
	entry: {
		app: './src/index.js',
	},
	plugins: [
		new CleanWebpackPlugin(),
		new HtmlWebpackPlugin(
			//{
			//	template: 'src/index.html' 
			//  必须指定模板才可以. 并不是, 默认是src.ejs
			//}
		), //默认模板src/index.ejs 默认输出index.html

		

	],
	module: {
    rules: [
      {
        test: /\.html$/,
        loader: 'html-loader'
      }],
  },
	//module: { 
	//	rules: [
	//		{
	//			test: /\.html$/,
	//			use: [
	//				{
	//					loader: "html-loader", //这个loader和htmlwebpackplugin冲突, 如果用了这个, 那么plugin就会不正常.
	//					options: {minimize: false}
	//				}
	//			]
	//		},
	//	]
	//},
	output: {
		filename: '[name].[contenthash].js',
		//使用filename: '[name].[contenthash].js', 保证有更新就刷缓存. 
		path: path.resolve(__dirname,'output/online'),
		//这里output中的文件不会被自动清除, 所以可以设置为git控制的目录.
		publicPath: '/',
	},
	optimization: {
		//把runtime独立出来, 不影响正常bundle的缓存
		runtimeChunk: 'single',
		moduleIds: 'deterministic', //这个可以, 没有这个也可以. 因为webpack5默认是这个.  
		//把node_modules单独打包, 单独缓存, 因为他们变化会比较少
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
};

