# Process values of attributes into space separated strings
processAttrs = (attrs) ->
  for own k, v of attrs
    attrs[k] = _.join.apply(null, [" "].concat(v))
    if _.isBlank(attrs[k])
      delete attrs[k]
  attrs

class NavItemBase
  constructor: (@text, isActive, @isDropdown) ->
    attrs =
      "class": []

    if isActive
      attrs["class"].push("active")
    if @isDropdown
      attrs["class"].push("dropdown")

    @attrs = processAttrs(attrs)

class FlatNavItem extends NavItemBase
  constructor: (text, routeName, activePath) ->
    @url = Router.routes[routeName].path()
    isActive = activePath == @url

    super(text, isActive, false)

class DropDownNavItem extends NavItemBase
  constructor: (text, isActive, @dropdownItems) ->
    super(text, isActive, true)

class DropdownItem
  constructor: (@text, path, activePath, @hasSound, @isOfficial) ->
    @url = "/demos/#{path}"
    isActive = activePath == @url
    attrs =
      "class": []
    if isActive
      attrs["class"].push("active")

    @attrs = processAttrs(attrs)

Template.layout.helpers(
  navItems: ->
    if !Router.current()?
      Log.warn("Router isn't yet defined")
      return []

    activePath = Router.current().path
    demos = Demos.find({}, sort: ["path"]).map((demo) -> new DropdownItem(demo.name, demo.path,
      activePath, demo.hasSound, demo.isOfficial))
    officialDemos = _.filter(demos, (demo) -> demo.isOfficial)
    contribDemos = _.filter(demos, (demo) -> !demo.isOfficial)
    isContribDemosActive = /^\/demos\/contrib\//.test(activePath)
    isOfficialDemosActive = !isContribDemosActive && /^\/demos\//.test(activePath)
    [
      new FlatNavItem("Home", "home", activePath),
      new DropDownNavItem("Demos", isOfficialDemosActive, officialDemos),
      new DropDownNavItem("Contributions", isContribDemosActive, contribDemos),
      new FlatNavItem("About", "about", activePath)
    ]
  socialLinks: [
    url: "https://twitter.com/chuckdemos"
    icon: "twitter"
  ,
    url: "http://github.com/aknuds1/chuckjs"
    icon: "github"
  ,
    url: "https://groups.google.com/forum/#!forum/chuckjs"
    icon: "envelope"
  ]
  officialDemosPorted: -> Demos.find({isOfficial: true}).count()
  officialDemosRemaining: 317
)

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
