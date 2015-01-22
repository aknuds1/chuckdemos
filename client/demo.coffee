Template.demo.helpers(
  isExecuting: -> Session.get("chuckExecuting")
)

# Chuck = require("chuck").Chuck
# window.Chuck = chuck = new Chuck()

Template.demo.events(
  "click #execute-chuck": ->
    executeChuck = ->
      if !Session.get("chuckExecuting")
        @Log.debug("Starting ChucK execution")
        Session.set("chuckExecuting", true)
        chuck.execute(code, args)
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

    {code, args} = getDemo()
    if chuck.isExecuting()
      chuck.stop()
      .done(->
        executeChuck()
      )
    else
      executeChuck()
    return
)
