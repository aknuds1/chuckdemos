getDemo = ->
  path = Router.current().params[0]
  Demos.findOne(path: path)

Template.demo.params = getDemo

Template.demo.isExecuting = -> Session.get("chuckExecuting")

Chuck = require("chuck").Chuck
window.Chuck = chuck = new Chuck()

Template.demo.events(
  "click #execute-chuck": ->
    executeChuck = ->
      if !Session.get("chuckExecuting")
        @Log.debug("Starting ChucK execution")        
        Session.set("chuckExecuting", true)
        chuck.execute(code)
        .done(->
          Session.set("chuckExecuting", false)
          @Log.debug("ChucK execution finished")
        , ->
          Session.set("chuckExecuting", false)
          @Log.debug("ChucK execution failed")
        )
      else
        @Log.debug("Stopping ChucK execution")
        Session.set("chuckExecuting", false)
        chuck.stop()
        .done(->
          @Log.debug("ChucK stopped successfully")
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
