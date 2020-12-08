import {random} from 'mlib'

import _ from 'lodash' # 测试外部库依赖

import ttt from './ttt/ttt.cs'

import style from  "./index.module.sass"
import React, { useState,useEffect }  from 'react'
import ReactDOM from 'react-dom'

z=random.randomlight 0
console.log z


y= random.randomcolor 0
console.log y

console.log JSON.stringify {ttt}




# 主面板
Floatpannel= (i) ->

	<main className={style.main}>

	hahaha, {z+y+JSON.stringify ttt}

	</main>

ReactDOM.render	<Floatpannel />,document.getElementById('reactcontainer')
