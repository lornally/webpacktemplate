
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


export Hello = () ->
  <div className="hello-world">
    <h1>Helyoujianmianlea</h1>
  </div>

ReactDOM.render	<Hello />,document.getElementById('reactcontainer')
