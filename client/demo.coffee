getDemo = ->
  path = Router.current().params[0]
  Demos.findOne(path: path)

Template.demo.params = getDemo

Template.demo.events(
  "click #execute-chuck": ->
    code = getDemo().code
    console.log("Executing code:\n#{code}")
)