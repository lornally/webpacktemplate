

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
