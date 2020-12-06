
###
* 拿到整数版本的随机数
* 因为random不包含1, 因此, 这个随机数也不包含max
* 因此传入数组的长度正好合适作为数组的索引
###
import {lightstr} from './color.cs'

export randomint=(max) ->
	(Math.random()*max)>>0

###
数组中取一个随机element
###
export e4arr = (p) ->
	p[randomint p.length]

# 随机一个颜色
export randomcolor = ->
	"rgb("+ (randomint 256)+","+(randomint 256 )+","+(randomint 256)+")"


# 随机一个量颜色
export randomlight = ->
	lightstr
		str:randomcolor 0
		isback:false




export default {
	randomint
	e4arr
	randomcolor
	randomlight
}
