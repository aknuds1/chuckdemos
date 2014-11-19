var Hapi = require('hapi')
var Path = require('path')
var server = new Hapi.Server(3000, {
  views: {
    engines: {
      html: require('handlebars')
    },
    path: Path.join(__dirname, 'views')
  }
})

server.route({
  method: 'GET',
  path: '/',
  handler: {
    view: 'index',
  },
})
server.route({
  method: 'GET',
  path: '/public/{param*}',
  handler: {
    directory: {
      path: 'public',
    },
  },
})
server.route({
  method: 'GET',
  path: '/bower_components/{param*}',
  handler: {
    directory: {
      path: 'bower_components',
    },
  },
})

server.pack.register({
  plugin: require('good'),
  options: {
    reporters: [
      {
        reporter: require('good-console'),
        args: [{log: '*', request: '*'}],
      },
      // {
      //   reporter: require('good-http'),
      //   args: ['http://prod.logs:3000', { error: '*' } , {
      //       threshold: 20,
      //       wreck: {
      //           headers: { 'x-api-key' : 12345 }
      //       }
      //   }]
      // },
    ],
  }
}, function (err) {
  if (err) {
    console.log(err)
    return
  }

  server.start(function () {
    console.log('Started')
    server.log(['debug'], 'Server running at ' + server.info.url)
  })
})
