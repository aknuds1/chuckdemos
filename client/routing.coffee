Router.configure(
  layoutTemplate: "layout"
)

Router.route('/', ->
  @render('home')
,
  {
    name: 'home'
  }
)
Router.route('/about', ->
  @render('about')
)

Router.route("/demos/:demo(.*)", ->
  @render("demo", {
    data: ->
      path = @params.demo
      Demos.findOne(path: path)
  })
, {
    onBeforeAction: ->
      # Eventually stop ChucK playback
      if window.Chuck? && Chuck.isExecuting()
        window.Chuck.stop()
        # TODO: Refactor!
        .done(-> Session.set("chuckExecuting", false))

      @next()
    ,
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
  }
)
