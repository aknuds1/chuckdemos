'use strict'
var demos;

var Demo = React.createClass({
  mixins: [ReactRouter.State,],

  render: function() {
    var demoId = this.getPath().slice('/demos/'.length)
    console.log('Rendering demo', demoId)
    var demo = _.find(demos, function (d) {
      return d.id === demoId
    })
    return (
      <div>{demo.code}</div>
    )
  }
})
