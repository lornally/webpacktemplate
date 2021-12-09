//生产环境用的配置文件
const {merge}=require('webpack-merge');
const common=require('./webpack.common.js');

module.exports=merge(common,{
	mode: 'production',
	externals: { //直接配置
		'Config': JSON.stringify({
			//server的url
			apiurl: 'http://39.100.155.145:30004/wuliu_back/uds/',
		})
	},
});
