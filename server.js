var Hapi = require('hapi')
var server = new Hapi.Server(3000)

server.route({
  method: 'GET',
  path: '/',
  handler: function (request, reply) {
    reply('Helluuuu')
  }
})
server.route({
  method: 'GET',
  path: '/{name}',
  handler: function (request, reply) {
    reply('Helluuuu ' + encodeURIComponent(request.params.name))
  }
})

server.start(function () {
  console.log('Server running at', server.info.url)
})
