getDemo = ->
  path = Router.current().params[0]
  Demos.findOne(path: path)

Template.demo.params = getDemo

Chuck = require("chuck").Chuck
chuck = new Chuck()

Template.demo.events(
  "click #execute-chuck": ->
    code = getDemo().code
    chuck.execute(code)
    .done(->
      console.log("ChucK execution finished")
    , ->
      console.log("ChucK execution failed!")
    )
    return
)