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
  constructor: (@text, routeName, activePath) ->
    @url = Router.routes[routeName].path()
    isActive = activePath == @url
    @classNames = []
    if isActive
      @classNames.push("active")

Template.layout.navItems = ->
  activePath = Router.current().path
  [
    new NavItem("Home", "home", activePath),
    new NavItem("Examples", null, activePath, [
      new DropdownItem("Demo0", "demo0", activePath),
      new DropdownItem("Demo1", "demo1", activePath),
      new DropdownItem("Demo2", "demo2", activePath)
    ]),
    new NavItem("About", "about", activePath)
  ]