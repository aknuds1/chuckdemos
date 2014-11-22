var Route = ReactRouter.Route
var Routes = ReactRouter.Routes
var NotFoundRoute = ReactRouter.NotFoundRoute
var DefaultRoute = ReactRouter.DefaultRoute
var Link = ReactRouter.Link

// TODO
var officialDemosPorted = 1
var officialDemosTotal = 2
var navItems = [
  {
    url: 'http://example.com',
    text: 'Example',
    isDropDown: false,
  },
  {
    url: 'http://examples.com',
    text: 'Examples',
    isDropDown: true,
    dropDownItems: [
      {
        hasSound: true,
        attrs: [],
        url: 'http://example.com/1',
        text: '1',
      },
    ],
  },
]

var SoundIcon = React.createClass({
  render: function () {
    return (<span></span>)
  },
})

var App = React.createClass({
    render: function () {
      navElements = _.map(navItems, function (navItem)  {
        if (!navItem.isDropDown) {
          return (
            <li>
              <a href={navItem.url}>{navItem.text}</a>
            </li>
          )
        } else {
          var dropDownElements = _.map(navItem.dropDownItems, function (dropDownItem) {
            var soundIcon = dropDownItem.hasSound ? (<SoundIcon/>) : ''
            return (
              <li role="presentation">
                <a role="menuitem" tabindex="-1" href={dropDownItem.url}>
                  {dropDownItem.text}
                  {soundIcon}
                </a>
              </li>
            )
          })

          return (
            <li className="dropdown">
              <a href="#" className="dropdown-toggle" data-toggle="dropdown">{navItem.text}</a>
              <ul className="dropdown-menu" role="menu">
                {dropDownElements}
              </ul>
            </li>
          )
        }
      })

      return (
        <div>
          <div className="navbar navbar-inverse navbar-fixed-top">
            <div className="container">
              <div className="navbar-header">
                <a className="navbar-brand" href="/">ChucK Demos</a>
              </div>
              <div className="navbar-collapse collapse">
                <ul className="nav navbar-nav">
                  {navElements}
                </ul>
              </div>
            </div>
          </div>
          <div className="container" role="main">
            <this.props.activeRouteHandler/>
          </div>
          <div id="footer">
            <hr className="no-top-margin"/>
            <div className="footer-content"><a href="https://github.com/spencersalazar/chuck/tree/master/src/examples">Official</a
                >&nbsp;demos ported: {officialDemosPorted}/{officialDemosTotal}</div>
            <div id="social" className="footer-content">
              {/*
              {{#each socialLinks}}
              <a href="{{url}}" target="_blank"><i className="fa fa-{{icon}}"></i></a>
              {{/each}}
              */}
            </div>
            <div className="footer-content">
              Want to help?&nbsp;<a href="https://github.com/aknuds1/chuck" target="_blank">ChucKJS</a>&nbsp;needs contributors
            </div>
            <div id="copyright" className="footer-content">
              <span className="text-muted">© 2014 Arve Knudsen</span>&nbsp;
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