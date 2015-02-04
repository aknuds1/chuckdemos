Template.demo.helpers(
  isExecuting: -> Session.get("chuckExecuting")
)

Template.demo.events(
  "click #execute-chuck": ->
    executeChuck = ->
      if !Session.get("chuckExecuting")
        @Log.debug("Starting ChucK execution")
        Session.set("chuckExecuting", true)
        try
          Module.ccall('executeCode', null, ['string', 'string'], [name, code])
          Session.set("chuckExecuting", false)
          @Log.debug("ChucK execution finished")
        catch err
          Session.set("chuckExecuting", false)
          @Log.debug("ChucK execution failed:\n#{err}")
      else
        # TODO: Won't work until ChucK is async
        @Log.debug("Stopping ChucK execution")
        Session.set("chuckExecuting", false)
        chuck.stop()
        .done(->
          @Log.debug("ChucK stopped successfully")
        )
      return

    {code, args, name} = @
    executeChuck()
    # if chuck.isExecuting()
    #   chuck.stop()
    #   .done(->
    #     executeChuck()
    #   )
    # else
    #   executeChuck()
    return
)
