






lan=''
str={}

setlocal= (local) ->
	lan = local

setstr = (s) ->
	str=s

localstr = (s) ->
	str[s][lan]


export default {
	setlocal
	setstr
	localstr
}




import str from './local/lang.cson'
import c24n from './c24n.cs'

# 如果使用默认local, 则无需设置
#c24n.setlocal 'en'
# 设置引入的字符串字典
#c24n.setstr str

#ls=c24n.localstr

# 拿到当前语言的: '黑化'
#console.log ls '黑化'
