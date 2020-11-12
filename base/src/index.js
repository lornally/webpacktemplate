import _ from 'lodash';
import './style.css';
import Icon from './2020.jpg';


function component() {
	const element=document.createElement('div');

	// lodash，现在通过一个 script 引入
	element.innerHTML=_.join(['Hello','webpack'],' ');
	element.classList.add('hello');
	// 将图像添加到我们已经存在的 div 中。
	const myIcon=new Image();
	myIcon.src=Icon;

	element.appendChild(myIcon);
	return element;
}

document.body.appendChild(component());
