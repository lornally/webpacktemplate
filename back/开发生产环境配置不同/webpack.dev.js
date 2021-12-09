//开发用的webpack配置文件

const { merge } = require('webpack-merge');
const common = require('./webpack.common.js');

module.exports = merge(common, {
  mode: 'development',
  devtool: 'inline-source-map',
  devServer: {
    contentBase: './output/online',
	},
	externals: { //直接配置
		'Config': JSON.stringify({
			//本机的url
			apiurl: 'http://localhost:30004/wuliu_back/uds/'
		})
	},
});
