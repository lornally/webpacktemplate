
import style from  "./style.module.sass"
import React from 'react'
import ReactDOM from 'react-dom'

e = React.createElement

class LikeButton extends React.Component
  constructor: (props) ->
    super props
    @state =  liked: false
  render: ->
    return 'You liked this.' if (@state.liked)
    e(
      'button'
      { onClick: () => @setState({ liked: true }) }
      'Like'
    )



#domContainer = document.querySelector '#reactcontainer'
#ReactDOM.render e(LikeButton), domContainer


export Hello = (props) ->
  <div className={style.moduleclass}>
    <h1>props hello</h1>
  </div>

ReactDOM.render	<Hello />,document.getElementById('reactcontainer')
