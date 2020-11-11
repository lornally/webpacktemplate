'use strict';
/**
 * 处理数据文件
 * 1. 缩减经纬度为3位小数
 * 2. 去重
 * 
 */ 

//import {point as hangzhou}  from './hangzhou3000.json';
import {point as xian} from './origin/xian500.json';
import {point as xian2} from './origin/xian501.json';
import  hangzhou from './origin/hangzhou3000.json';
import fs from 'fs';

import {tt} from './d1';

!function () {

	console.log(tt);
	const hz =hangzhou;
	const x =xian;
	const y =xian2;
	const out={
		hangzhou:{},
		xian:{},
	};

	deal({point:hz.point, city:'hangzhou'});
	deal({point:x, city:'xian'});
	deal({point:y, city:'xian'});
	savefile({json: Object.values(out['hangzhou']),filename: 'hangzhou.json'});

	savefile({json:Object.values(out['xian']),filename: 'xian.json'});

	function deal({point,city}) {
		for(let i=0;i<point.length;i++) {
			const x=point[i];
			const E = x.E*1000>>0;
			const N = x.N*1000>>0;
			const key= 'E'+E+'N'+N;
			out[city][key]=x;
		}
	
	}
	
	
	function savefile({json,filename="temptest.txt"}) {
	
		fs.writeFile(filename,JSON.stringify(json),function(err) {
			console.log('文件写入',filename);
			if(err) {
				console.log(err);
			}
		});
	
	}
	
}()

