

###
 * 这里是寻找某个位置的点的函数, 比如中位数, 1/4位数等等
 * @param {输入的用来寻找的数组} arra
 * @param {每个元素拿值的方法} valu
 * @param {要找到顶部的第几个元素} top
 * 这个算法类似于快速排序. 每次只排一边, 知道找到需要的值.
 * 最终返回的是满足条件的值.
 * 目标是统计数据的提取, 比如中位数, 3/4位数等等.
 

export function top(arra, valu, top) {
	if (arra.length === 0) return [];
	const lesser = [];
	const greater = [];
	const p = arra[0];
	for (let i = 1; i < arra.length; i++) {
		if (valu(arra[i]) > valu(p)) {
			greater.push(arra[i]);
		} else {
			lesser.push(arra[i]);
		}
	}

	// 终结条件很重要, p是第top个, 或者less==top个, 其实都可以返回了.这样就是正好top个或者多一个.
	if (top - 2 < lesser.length && lesser.length < top + 1) return p;
	if (lesser.length > top) {
		return top(lesser, valu, top);
	}
	return top(greater, valu, top - lesser.length - 1); // 这里要把p的位置减掉, 不然就bug了.
}
###

big= (a, b) -> a>b #默认这个是找最大的数字.
export top1 = ({arr,xwiny=big})->
	a=[arr...] # 不改变输入的纯函数
	e=a.shift 0
	e = j for j in a when xwiny j,e
	e
	# 另一个纯函数, 但是重复判断了第一个元素, 不过很可能效率更好
	#e=arr[0]
	#	e =j for j in arr when xwiny j,e
