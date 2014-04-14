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
  )
)
