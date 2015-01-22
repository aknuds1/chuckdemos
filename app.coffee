lodash.mixin(_.str.exports())
this._ = lodash
Logger.setLevel('info')
@Log = new Logger("ChuckDemos")
chuckLog = new Logger("ChucKJS")

if Meteor.isClient
  chuckModule = require('chuck')
  #chuckModule.setLogger(chuckLog)

@Demos = new Meteor.Collection("Demos")
