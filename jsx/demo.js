'use strict'
var demos
var SoundIcon

var Button = ReactBootstrap.Button

var Demo = React.createClass({
  mixins: [ReactRouter.State,],

  render: function() {
    var demoId = this.getPath().slice('/demos/'.length)
    console.log('Rendering demo', demoId)
    var demo = _.find(demos, function (d) {
      return d.id === demoId
    })
    var soundIcon = demo.hasSound ? (<span>&nbsp;<SoundIcon/></span>) : ''
    return (
      <div>
        <div className="jumbotron">
          <h1>{demo.name}{soundIcon}</h1>
          <p>{demo.description}</p>
        </div>
        <Button id="execute-chuck" bsStyle="primary">
          <i className="fa fa-play"/>
        </Button>
        <div className="chuck-code">
          <pre className="no-btm-margin">
            {demo.code}
          </pre>
        </div>
      </div>
    )
  }
})
