 # 第一个coffee文件. 测试下node环境下, coffee的运行.

import testinput from './input.cson'

points = [
	[192, 168]
	[176, 188]
]
distinct = [
	[{ key: '5v1', value: 55 },
	{key:'5v1', value:55},{key:'5v1', value:55},{key:'5v1', value:55},]
	[{key:'5v1', value:55},{key:'5v1', value:55},
	{key:'5v1', value:55},{key:'5v1', value:55},]
]

console.log JSON.stringify testinput
