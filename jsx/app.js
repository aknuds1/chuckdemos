var Route = ReactRouter.Route
var Routes = ReactRouter.Routes
var NotFoundRoute = ReactRouter.NotFoundRoute
var DefaultRoute = ReactRouter.DefaultRoute
var Link = ReactRouter.Link
var Navbar = ReactBootstrap.Navbar
var Nav = ReactBootstrap.Nav
var NavItem = ReactBootstrap.NavItem
var DropdownButton = ReactBootstrap.DropdownButton
var MenuItem = ReactBootstrap.MenuItem

// TODO
var officialDemosPorted = 1
var officialDemosTotal = 2
var navItems = [
  {
    url: '/',
    text: 'Home',
    routeName: 'home',
    isDropDown: false,
  },
  {
    text: 'Demos',
    isDropDown: true,
    routeName: 'demos',
    dropDownItems: [
      {
        hasSound: true,
        attrs: [],
        url: 'http://example.com/1',
        text: '1',
      },
    ],
  },
  {
    url: '/about',
    text: 'About',
    routeName: 'about',
    isDropDown: false,
  },
]
var socialLinks = [
  {
    url: 'https://twitter.com/chuckdemos',
    icon: 'twitter',
  },
  {
    url: 'http://github.com/aknuds1/chuck',
    icon: 'github',
  },
  {
    url: 'https://groups.google.com/forum/#!forum/chuckjs',
    icon: 'envelope',
  },
]

var SoundIcon = React.createClass({
  render: function () {
    return (
      <i className="fa fa-headphones slightly-transparent" data-toggle="tooltip" data-placement="right"
      title="" data-original-title="Generates sound"></i>
    )
  },
})

var App = React.createClass({
    render: function () {
      var activeDescriptor = this.props.activeRouteHandler()
      var routeName = activeDescriptor.props.name

      var navElements = _.map(navItems, function (navItem)  {
        var props = {}
        if (navItem.routeName === routeName) {
          props.className = 'active'
        }
        if (!navItem.isDropDown) {
          return (
            <NavItem {...props} href={navItem.url}>{navItem.text}</NavItem>
          )
        } else {
          var dropdownElements = _.map(navItem.dropDownItems, function (dropDownItem) {
            var soundIcon = dropDownItem.hasSound ? (<span>&nbsp;<SoundIcon/></span>) : ''
            return (
              <MenuItem>
                  {dropDownItem.text}{soundIcon}
              </MenuItem>
            )
          })

          return (
            <DropdownButton title={navItem.text}>
              {dropdownElements}
            </DropdownButton>
          )
        }
      })

      var socialLinkElements = _.map(socialLinks, function (socialLink) {
        return (
          <a href={socialLink.url} target="_blank"><i className={'fa fa-3x fa-' + socialLink.icon}></i></a>
        )
      })

      return (
        <div>
          <Navbar fixedTop={true} inverse={true} brand={(<a href="/">ChucK Demos</a>)}>
            <Nav>
              {navElements}
            </Nav>
          </Navbar>
          <div className="container" role="main">
            <this.props.activeRouteHandler/>
          </div>
          <div id="footer">
            <hr className="no-top-margin"/>
            <div className="footer-content">
              <a href="https://github.com/spencersalazar/chuck/tree/master/src/examples">Official</a>
              &nbsp;demos ported: {officialDemosPorted}/{officialDemosTotal}
            </div>
            <div id="social" className="footer-content">
              {socialLinkElements}
            </div>
            <div className="footer-content">
              Want to help?&nbsp;<a href="https://github.com/aknuds1/chuck" target="_blank">ChucKJS</a>
              &nbsp;needs contributors
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
      <DefaultRoute name="home" handler={Home}/>
    </Route>
  </Routes>
)
React.render(routes, document.body)