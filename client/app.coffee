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
  constructor: (@text, path, activePath, @hasSound) ->
    @url = "/demos/#{path}"
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
  demos = Demos.find({}, sort: ["path"]).map((demo) -> new DropdownItem(demo.name, demo.path, activePath,
  demo.hasSound))

  [
    new NavItem("Home", "home", activePath),
    new NavItem("Demos", null, activePath, demos),
    new NavItem("About", "about", activePath)
  ]

Template.layout.socialLinks = [
  url: "https://twitter.com/chuckdemos"
  icon: "twitter"
,
  url: "http://github.com/aknuds1/chuckjs"
  icon: "github"
]

Template.soundIcon.rendered = ->
  $haveTooltips = $(this.findAll("[data-toggle='tooltip']"))
  $haveTooltips.tooltip()
  return

Meteor.startup(->
  Meteor.subscribe("demos")

  SEO.config(
    title: 'ChucK Demos'
    meta:
      description: "Executable demos of the ChucK music programming language"
  )
)
