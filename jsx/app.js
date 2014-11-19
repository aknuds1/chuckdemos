var Route = ReactRouter.Route
var Routes = ReactRouter.Routes
var NotFoundRoute = ReactRouter.NotFoundRoute
var DefaultRoute = ReactRouter.DefaultRoute
var Link = ReactRouter.Link

var App = React.createClass({
    render: function () {
      return (
        <div>
          <header>
            <ul>
              <li><Link to="app">Home</Link></li>
              <li><Link to="about">About</Link></li>
            </ul>
          </header>

          <this.props.activeRouteHandler/>
        </div>
      )
    }
})

var routes = (
  <Routes location="history">
    <Route name="app" path="/" handler={App}>
      <Route name="about" handler={About}/>
      <DefaultRoute handler={Home}/>
    </Route>
  </Routes>
)
React.render(routes, document.body)