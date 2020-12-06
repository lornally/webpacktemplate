export sleep = (ms) ->
	new Promise (resolve) ->
		setTimeout resolve, ms


export gethhmm =(timestamp=Date.now())->
	t=new Date(+timestamp)
	t.getHours()+':'+t.getMinutes()

export gethhmmss =(timestamp=Date.now())->
	t=new Date(+timestamp)
	t.getHours()+':'+t.getMinutes()+':'+t.getSeconds()
