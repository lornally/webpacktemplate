###
 * 关于颜色的库, 这个库会被重写, 因为hsl的亮度判断可以认为是错的. 所以可以保留hsl相关的函数, 但是, 实际应用函数需要重写.
 *
###
import colorname from './colorname.cson'

darkcolor= 'rgba(44,44,44,1)' #dark的基础颜色
lightcolor= 'rgba(200,200,200,1)'





###*
 * ---------------------单独处理前景或者背景, 配合darkcss的思路---------------------------
 * 亮度判断逻辑 g>100, r>200, 或者g+r>300
 * 亮度处理逻辑 t=max(100-g, 200-r), t+r, t+g, t+b
 *
 * 暗度判断逻辑 g<60 r<100 b<150
 * 暗度处理逻辑 t=max(g-60, r-100, b-150), r-t, g-t, b-t
 *
 ###

	###*
	 * rgbok
	 * 判断颜色是否需要处理
	 *  * 亮度判断逻辑 g>100, r>200, 或者g+r>300
	 *  * 暗度判断逻辑 g<60 r<100 b<150
	 * 参数
	 * 	rgb:{r,g,b}
	 *  isback: 是否为背景图片
	 * 返回值
	 * 		true: 不需要处理
	 * 		false: 需要处理
	 ###
rgbok=({rgb,isback=true})->
	{r,g,b}=rgb
	if isback then 	g<60 && r<100 && b<150 else r+g>300
			#暗度判断
			#光明模式, 如果亮度<0.7则需要处理, 否则就不需要处理




###*
 * 从str到调亮的颜色str
 *  这里处理一个style string的亮度
 * 纯函数
 * str: 一个颜色字符串
 * isback: 是否为背景
 ###
export lightstr=({str,isback=true}) ->
	return false if(!str)
	
	#如果是initial, 那么直接用我的值.
	return (if isback then darkcolor else lightcolor) if str=="initial"
	
	#fixme 暂时在这里忽略css var  #todo
	return (if isback then darkcolor else lightcolor)if /var\(--/.test(str)
	l=lightrgb {rgb: str2rgb(str),isback}
	if l then rgb2str(l) else false



	###*
	 * lightrgb核心亮度处理函数
	 *  * 亮度处理逻辑 t=max(100-g, 200-r), t+r, t+g, t+b
	 *  * 暗度处理逻辑 t=max(g-60, r-100, b-150), r-t, g-t, b-t
	 *
	 ###
export	lightrgb=({rgb,isback=true}) ->
	return false if(rgbok({rgb,isback}))
	{r,g,b}=rgb
	if (isback)  #处理暗黑背景
		t= Math.max(g-60,r-100, b-150)
		r-=t
		g-=t
		b-=t
	else  #处理明亮前景
		t= Math.max(100-g,200-r)
		r+=t
		g+=t
		b+=t
	{r,g,b}





###*
 * --------------对比度逻辑, 配合darkstyle-----------------
 * 这里的计算未必合适.
###




		###*
		 * 从str到亮度
		 ###
export getlight= (str) ->
	getrgblight str2rgb str
		
export getdark=(str) ->
	getrgbdark str2rgb str
		



###*
	* 拿到视觉亮度
	* 用来判断颜色是否够亮
	* 未来用荧光体发光能量来计算数值.
###
getrgblight= ({r,g,b})->
	r=r*1.2
	g=g*1.7
	mlight({r,g,b}).light

###*
	* 拿到视觉暗度
	* 用来判断颜色是否够暗
	*
###
getrgbdark=({r,g,b})->
	r=r*1.3
	g=g*1.2
	mlight({r,g,b}).light

mlight=({r,g,b})->
	if r > g
		b1=r
		b2=g
	else
		b1=g
		b2=r
	
	if b < b2
		b3=b
	else if b < b1
		b3=b2
		b2=b
	else
		b3=b2
		b2=b1
		b1=b
			# 这里很不严谨, 亮度的心理阈限测量或许能让这个计算更精确.
	light: (b1+b2/6)*2/3,max: [b1,b2,b3]
	








###
	* 基础工具函数-------------------------------------------------------
	* 判断两个rgbstr实际相等
###

export samergbstr=(rgbstr1,rgbstr2)->
	{r: r1,g: g1,b: b1}=str2rgb(rgbstr1)
	{r: r2,g: g2,b: b2}=str2rgb(rgbstr2)
	r1==r2&&g1==g2&&b1==b2


###*
* 3种情况
* 1. rgb情况: 从"rgb(154, 154, 0)"转化为: {r:154,g:154,b:0,}
* "rgba(0, 0, 0, 0)" 还需兼容此种情况
* 2. 16进制情况:  #fc2  #fc29 #fc292923 #fc2929
* 3. 颜色名: white, black, organge
*###

str2rgb=(str)->

	#"rgb(154, 154, 0)"
	reg=/rgba?\(([0-9]{1,3}), ?([0-9]{1,3}), ?([0-9]{1,3})(, ?([0-9.%]+))?\)/i
	c=reg.exec str

	#16进制颜色
	c?=hex2rgb(str)

	#再判断名字颜色:
	c?= colorname[str] && hex2rgb(hex)
	
	return false unless c?


	#透明度
	a= if c[5]? then c[5] else 1
	{r: +c[1],g: +c[2],b: +c[3],a} #这里用+是为了把字符串转为数字, 不然会发生很隐蔽的bug.


	###
	 * 从rgb到str
	 *###
rgb2str=({r,g,b,a=1}) ->
	if a>0.99 then  "rgb("+r+","+g+","+b+")" else "rgba("+r+","+g+","+b+","+a+")"


	###
	 * 从16进制到rgb
	 *  #fc2  #fc29 #fc292923 #fc2929, 3,4,6,8都有可能
	###


hex2rgb=(str) ->
	reg=/#([^#]*)/i #判断#62fa89这种类似方式的颜色值
	c=reg.exec(str)
	return false unless c?[1]? 	#c1不存在需要return
	x=c[1]
	y=[]
	switch x.length
		when 3
			y[1]=parseInt(''+x[0]+x[0],16)
			y[2]=parseInt(''+x[1]+x[1],16)
			y[3]=parseInt(''+x[2]+x[2],16)
		when 4
			#y[1]=parseInt(x[0],16);  /20201028修正错误, 这个会把fff转化为 r15g15b15, 其实应该是r255g255b255
			y[1]=parseInt(''+x[0]+x[0],16)
			y[2]=parseInt(''+x[1]+x[1],16)
			y[3]=parseInt(''+x[2]+x[2],16)
			y[5]=parseInt(x[3],16)/255
		when 6
			y[1]=parseInt(''+x[0]+x[1],16)
			y[2]=parseInt(''+x[2]+x[3],16)
			y[3]=parseInt(''+x[4]+x[5],16)
		when 8
			y[1]=parseInt(''+x[0]+x[1],16)
			y[2]=parseInt(''+x[2]+x[3],16)
			y[3]=parseInt(''+x[4]+x[5],16)
			y[5]=parseInt(''+x[6]+x[7],16)/255
		#不满足上面四个情况, 直接返回false
		else return false
	y

	#console.log(str2rgb('white')); #test






test = ->
	result=window.luoclr.lightstr str:'white', isback:true
	console.log {result}


#test()
