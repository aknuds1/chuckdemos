Router.configure(
  layoutTemplate: "layout"
)

Router.map(->
  @route("home",
    path: "/"
    template: "home"
  )
)
Router.map(->
  @route("about",
    path: "/about"
  )
)
Router.map(->
  @route("demo",
    path: "/demos/:demo(*)"
    onAfterAction: ->
      if !Meteor.isClient
        return

      demo = Demos.findOne(path: this.params.demo)
      if !demo?
        return

      SEO.set(
        title: "ChucK Demo: #{demo.name}"
        meta:
          description: demo.description
      )
  )

  Router.before(->
    # Eventually stop ChucK playback
    if window.Chuck? && Chuck.isExecuting()
      window.Chuck.stop()
      # TODO: Refactor!
      .done(-> Session.set("chuckExecuting", false))
  )
)
