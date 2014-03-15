class NavItem
  constructor: (@text, routeName, activePath, @dropdownItems=null) ->
    @isDropdown = @dropdownItems?
    if !@isDropdown
      @url = Router.routes[routeName].path()
      isActive = activePath == @url
    @classNames = ""
    if @isDropdown
      isActive = activePath.slice(0, 6) == "/demos"
      @classNames += " dropdown"
    if isActive
      @classNames += " active"

class DropdownItem
  constructor: (@text, url, activePath) ->
    @url = "/demos/#{url}"
    isActive = activePath == @url
    @classNames = []
    if isActive
      @classNames.push("active")

Template.layout.navItems = ->
  activePath = Router.current().path
  examples = Demos.find().map((demo) -> new DropdownItem(demo.name, demo.path, activePath))

  [
    new NavItem("Home", "home", activePath),
    new NavItem("Examples", null, activePath, examples),
    new NavItem("About", "about", activePath)
  ]