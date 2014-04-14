# Process values of attributes into space separated strings
processAttrs = (attrs) ->
  for own k, v of attrs
    attrs[k] = _.join.apply(null, [" "].concat(v))
    if _.isBlank(attrs[k])
      delete attrs[k]
  attrs

class NavItem
  constructor: (@text, routeName, activePath, @dropdownItems=null) ->
    @isDropdown = @dropdownItems?
    if !@isDropdown
      @url = Router.routes[routeName].path()
      isActive = activePath == @url

    attrs =
      "class": []
    if @isDropdown
      isActive = activePath.slice(0, 6) == "/demos"
      attrs["class"].push("dropdown")
    if isActive
      attrs["class"].push("active")
    @attrs = processAttrs(attrs)

class DropdownItem
  constructor: (@text, url, activePath) ->
    @url = "/demos/#{url}"
    isActive = activePath == @url
    attrs =
      "class": []
    if isActive
      attrs["class"].push("active")

    @attrs = processAttrs(attrs)

Template.layout.navItems = ->
  if !Router.current()?
    Log.warn("Router isn't yet defined")
    return []

  activePath = Router.current().path
  demos = Demos.find().map((demo) -> new DropdownItem(demo.name, demo.path, activePath))

  [
    new NavItem("Home", "home", activePath),
    new NavItem("Demos", null, activePath, demos),
    new NavItem("About", "about", activePath)
  ]

Meteor.startup(->
  Meteor.subscribe("demos")
)
