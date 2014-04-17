getDemo = ->
  path = Router.current().params[0]
  Demos.findOne(path: path)

Template.demo.params = getDemo

Chuck = require("chuck").Chuck
window.Chuck = chuck = new Chuck()

Template.demo.events(
  "click #execute-chuck": ->
    executeChuck = ->
      chuck.execute(code)
      .done(->
        @Log.debug("ChucK execution finished")
      , ->
        @Log.debug("ChucK execution failed")
      )
      return

    code = getDemo().code
    if chuck.isExecuting()
      chuck.stop()
      .done(->
        executeChuck()
      )
    else
      executeChuck()
    return
)
