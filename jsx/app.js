var Route = ReactRouter.Route
var Routes = ReactRouter.Routes
var NotFoundRoute = ReactRouter.NotFoundRoute
var DefaultRoute = ReactRouter.DefaultRoute
var Link = ReactRouter.Link

// TODO
var officialDemosPorted = 1
var officialDemosTotal = 2

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
          <div id="footer">
            <hr class="no-top-margin"/>
            <div class="footer-content"><a href="https://github.com/spencersalazar/chuck/tree/master/src/examples">Official</a
                >&nbsp;demos ported: {officialDemosPorted}/{officialDemosTotal}</div>
            <div id="social" class="footer-content">
              {/*
              {{#each socialLinks}}
              <a href="{{url}}" target="_blank"><i class="fa fa-{{icon}}"></i></a>
              {{/each}}
              */}
            </div>
            <div class="footer-content">
              Want to help?&nbsp;<a href="https://github.com/aknuds1/chuckjs" target="_blank">ChucKJS</a>&nbsp;needs contributors
            </div>
            <div id="copyright" class="footer-content">
              <span class="text-muted">© 2014 Arve Knudsen</span>&nbsp;
              <a href="https://www.gittip.com/Arve%20Knudsen/" target="_blank">
                <img src="http://img.shields.io/gittip/Arve%20Knudsen.png"/>
              </a>
            </div>
          </div>
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