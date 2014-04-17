getDemo = ->
  path = Router.current().params[0]
  Demos.findOne(path: path)

Template.demo.params = getDemo

Chuck = require("chuck").Chuck
window.Chuck = chuck = new Chuck()

Template.demo.events(
  "click #execute-chuck": ->
    code = getDemo().code
    chuck.execute(code)
    .done(->
      @Log.debug("ChucK execution finished")
    , ->
      @Log.debug("ChucK execution failed")
    )
    return
)
