import _ from 'lodash';
import './style.css';
import Icon from './2020.jpg';
import Data from './data.xml';
import Notes from './data.csv';
import toml from './data.toml';
import yaml from './data.yaml';
import json from './data.json5';

//预缓存, 未来需要的内容
//生成的html: <link rel="prefetch" href="login-modal-chunk.js">
//import(/* webpackPrefetch: true */ 'lodash');

//预加载, 本页需要的内容
//生成html: <link rel="preload">
//import(/* webpackPreload: true */ 'lodash');


// 没有警告
import jsond from './data.json';

// 显示警告，规范不允许这样做。但是可以这样做.
import {foo} from './data.json';


function component() {
	const element=document.createElement('div');

	// lodash，现在通过一个 script 引入
	element.innerHTML=_.join(['Hello','webpack',Data,Notes,jsond,foo,toml,yaml,json],' ');
	element.classList.add('hello');
	// 将图像添加到我们已经存在的 div 中。
	const myIcon=new Image();
	myIcon.src=Icon;

	element.appendChild(myIcon);
	return element;
}

document.body.appendChild(component());



function getComponent() {

	return import(/* webpackPreload: true */ 'lodash').then(({default: _}) => {
		const element=document.createElement('div');

		element.innerHTML=_.join(['Hello','promise webpack'],' ');

		return element;

	}).catch(error => 'An error occurred while loading the component');
}



//async 写法
async function agetComponent() {

	const element=document.createElement('div');
	const {default: _}=await import(/* webpackPrefetch: true */ 'lodash');

	element.innerHTML=_.join(['Hello','async webpack'],' ');

	return element;
}

(async () => {
	const compo=await agetComponent();
	document.body.appendChild(compo);

	getComponent().then(component => {
		document.body.appendChild(component);
	})
})();
