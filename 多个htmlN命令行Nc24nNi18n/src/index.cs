
import style from  "./style.module.sass"
import React, { useState }  from 'react'
import ReactDOM from 'react-dom'

#e = React.createElement

#class LikeButton extends React.Component
#  constructor: (props) ->
#    super props
#    @state =  liked: false
#  render: ->
#    return 'You liked this.' if (@state.liked)
#    e(
#      'button'
#      { onClick: () => @setState({ liked: true }) }
#      'Like'
#    )



#domContainer = document.querySelector '#reactcontainer'
#ReactDOM.render e(LikeButton), domContainer


export Hello = (props) ->
	[count, setCount] = useState(0) # initialize state
	<div className={style.moduleclass}>
		<h1>props hello hahaha oeuaoeu {props.name}</h1>
		<p>You clicked {count} times</p>
      <button onClick={ -> setCount count + 1}>
        Click me
      </button>
  </div>

ReactDOM.render	<Hello name="天才"/>,document.getElementById('reactcontainer')
