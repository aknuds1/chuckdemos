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
  @route("demo0",
    path: "/demos/basic/demo0"
    template: "demo0"
  )
)
Router.map(->
  @route("demo1",
    path: "/demos/basic/demo1"
    template: "demo1"
  )
)
Router.map(->
  @route("demo2",
    path: "/demos/basic/demo2"
    template: "demo2"
  )
)
