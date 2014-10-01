getDemo = ->
  path = Router.current().params[0]
  demo = Demos.findOne(path: path)
  demo

Template.demo.helpers(
  params: getDemo
  isExecuting: -> Session.get("chuckExecuting")
  hasSound: ->
    demo = Template.demo.params()
    demo? && demo.hasSound
)

Template.demo.events(
  "click #execute-chuck": ->
    executeChuck = ->
      @Log.debug("Starting ChucK execution")
      Session.set("chuckExecuting", true)
      # TODO: Pass args (pseudo commandline arguments) to ChucK
      # TODO: Make ChucK execution asynchronous, so that it can be e.g. stopped
      Module.ccall('executeCode', null, ['string', 'string'],
        ['Demo', code])
      Session.set("chuckExecuting", false)
      @Log.debug("ChucK execution finished")

    {code, args} = getDemo()
#    if chuck.isExecuting()
#      chuck.stop()
#      .done(->
#        executeChuck()
#      )
#    else
    if !Session.get("chuckExecuting")
      executeChuck()
    else
      @Log.debug("Stopping ChucK execution")
      Session.set("chuckExecuting", false)
      chuck.stop()
      @Log.debug("ChucK stopped successfully")
    return
)
