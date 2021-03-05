import style from  "./style.module.sass";

//import  "./style.module.css"; 匿名import不得行, 因为无法引用了.

console.log('JSLOAD');

const element = document.createElement('div');

 
	element.innerHTML =' wenzichuanaoeu	';


	//element.classList.add('moduleclass'); //字符串失效的, 因为这个方式是全局作用域css的引用方式, 引用[ :global(.moduleclass) ]就用这个方似乎
	//element.className=style.moduleclass; //.属性方式成功
	element.classList.add(style['moduleclass']); //只要是属性方式就会成功.

	document.body.appendChild(element);

