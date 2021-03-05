
/**
 * 这里写一个通用的顶部排序.
 * 2019-04-04 by m 这里是所有排序的入口
 * arra是一个需要排序的数组.
 * valu是得到比较值的方法.
 * 判断大小会f(a[i]) > f(a[j]). 这样来判断.
 * 返回值, 从小到大
 * top, 是说返回多少个.
 * @param {需要排序的数组} area
 * @param {排序比较值} valu
 * @param {限制条件} top 只排前top名内容.
 * 这个排序是找到最小的top个元素, 作为数组返回.
 * 2020-10-17 by m 这个函数虽然放在test目录, 但是, 他是正常要用的.
 * 改名为sort, 并且改变导出方式
 * 2020-10-19 
 * todo 改造这个函数, 判断的时候, 默认判断对象的dis属性, 如果没有dis属性才会用函数求比较值. 
 * todo 改造这个方法, 1. 本地的git单独控制的库里面. 2. 用coffee重写.
 */
//import {log} from './log.js';

 export function sort(arra,valu,top=Infinity) {
	// 这里写个容错代码, 2019-4-24 不必了, 原因是最终的mergemin已经
	// top = arra.length > top ? top : arra.length;
	if(arra.length<1)return [];
	// 如果需要拿到顶部的几个那么使用heapmin;
	if(top<arra.length/2) return heapmin(arra,valu,top);

	// 如果拿到前面的一些, 但是大于一半, 那么快排更合理.
	if(top<arra.length) return quickmin(arra,valu,top);

	// 如果拿到所有的排序, 我们使用归并.
	return mergemin(arra,valu);
}

/**
 *
 * 堆排序, 这个排序对付大数据量是有问题的, 重复计算较多.
 * @param {需要排序的数组} area
 * @param {排序比较值} valu
 * @param {限制条件} top 只排前top名内容.
 * 这个排序是找到最小的top个元素, 作为数组返回.
 */

function heapmin(arra,valu,top=Infinity) {
	const r=[];

	function swap(i,j) {
		const tmp=arra[i];
		arra[i]=arra[j];
		arra[j]=tmp;
	}
	/**
	 * 父子三人, 最小的当爸爸. 然后重排儿子.
	 * @param {爸爸位置} dad
	 * @param {整个操作长度} l
	 */
	function min(dad,l) {
		let son=(dad<<1)+1;
		if(son>l) return; // 没有儿子跳出去.
		if(son+1<l&&valu(arra[son])>valu(arra[son+1])) son++; // 找到小儿子.
		if(valu(arra[dad])>valu(arra[son])) {
			// 爸爸不是最小的, 证明没排好.
			swap(dad,son);
			min(son,l);
		}
	}
	const l=arra.length-1;
	for(let i=(l-1)>>1;i>-1;i--) {
		min(i,l); // 初始化
	}
	// log('littletop, arra:',arra);
	// 先將第一個元素和已排好元素前一位做交換，再從新調整，直到排序完畢
	for(let i=l;i>l-top;i--) {
		r.push(arra[0]); // 把最小的放进去.
		swap(0,i);
		min(0,i-1); //		min(0, i);原本的bug是, 把最小值又排进去了. 奶奶的.....20190318
	}
	// log('littletop, arra:',arra, '  r:',r);

	return r;
}

/**
 * 归并排序:  合并多个内部有序的数组.
 * @param {需要排序的数组} arra
 * @param {排序比较值} f
 */

function mergemin(arra,f) {

	let orderorphan=arra.map(e => [e]);
	for(let i=0;i<orderorphan.length;i++) {
		// 归并排序需要初始化哨兵.
		orderorphan[i].push({
			dis: Infinity,
		});
	}
	while(orderorphan.length>1) {
		// 归并排序.
		const re=[];
		for(let i=0;i<orderorphan.length;i+=2) {
			if(i+1===orderorphan.length) {
				// 如果i已经是最后一个元素了.
				re.push(orderorphan[i]);
				continue;
			}
			re.push(union(orderorphan[i],orderorphan[i+1],f));
		}
		orderorphan=re; // 一轮循环结束, 把orderphan设置为re
	}
	orderorphan=orderorphan[0]; // 所有元素都合并到了第一个数组
	orderorphan.splice(-1,1); // 截断尾部哨兵.
	return orderorphan;
}

/**
 * 合并两个数组, 数组
 * @param {*} a1
 * @param {*} a2
 * @param {排序比较值} f
 * 20181224补充逻辑, 如果完全相同的两个距离, 不再插入了.
 */

function union(a1,a2,f) {
	let l=0;
	let r=0;
	const a=[];
	for(let i=0;i<a1.length+a2.length-1;i++) {
		if(f(a1[l])<f(a2[r])) {
			a.push(a1[l]);
			l++;
			continue;
		}
		a.push(a2[r]);
		r++;
		continue;
	}

	return a;
}
//对外调用函数, 需要加哨兵.
export function uni(a1,a2,f) {
	if (a1.length==0||a2.length==0) {
		return [...a1, ...a2];
	}
	a1.push({
		dis: Infinity,
	});
	a2.push({
		dis: Infinity,
	});
	const r=union(a1,a2,f);
	r.splice(-1,1);
	return r;
}

/**
 *
 * 快排序, 非常适合对付大数据量.
 * @param {需要排序的数组} t
 * @param {排序比较值} f
 * @param {限制条件} top 只排前top名内容.
 * 这个排序是找到最小的top个元素, 作为数组返回.
 */

function quickmin(t,f,top=Infinity) {
	if(t.length===0) return [];
	const lesser=[];
	let greater=[];
	const p=t[0];
	for(let i=1;i<t.length;i++) {
		if(f(t[i])>f(p)) {
			greater.push(t[i]);
		} else {
			lesser.push(t[i]);
		}
	}
	if(lesser.length>top) {
		greater=[];
		t=[];
		return quickmin(lesser,f,top);
	}

	t=[];
	return quickmin(lesser,f).concat(p,quickmin(greater,f));
}
