this._ = lodash
_.mixin(_.str.exports());
Logger.setLevel('info')
@Log = new Logger("ChuckDemos")
chuckLog = new Logger("ChucKJS")

if Meteor.isClient
  chuckModule = require('chuck')
  chuckModule.setLogger(chuckLog)

@Demos = new Meteor.Collection("Demos")

class Demo
  constructor: (@path, @name, @description, @code) ->

if Meteor.isServer
  Meteor.startup(->
    Demos.remove({})

    Demos.insert(new Demo("basic/demo0", "Demo 0", "Basic demo showing time and duration.", """5::second + now => time later;

while( now < later )
{
  <<<now>>>;
  1::second => now;
}

<<<now>>>;
"""))
    Demos.insert(new Demo("basic/demo1", "Demo 1", "Candidate for most trivial demo.", """0 => int a => int t;
1 => int b;
15 => int c;

while( c > 0 )
{
  a + b => t;
  b => a;
  <<<t => b>>>;
  c - 1 => c;
}
"""))
    Demos.insert(new Demo("basic/demo2", "Demo 2", "Really lame!", """// set the global gain
.1 => dac.gain;

SinOsc oscarray[5];
for(0 => int i; i<5; i++) {

  oscarray[i] => dac;
  Math.pow(2, i) * 110.0 => oscarray[i].freq;

}

for(0 => int i; i<5; i++) {

  oscarray[i] =< dac;
  1::second => now;

}
"""))
    Demos.insert(new Demo("basic/demo3", "Demo 3", "Super lame", """Gain g => dac;
// set gain
.5 => g.gain;

110.0 => float freq;
6 => int x;

// loop
while( x > 0 )
{
    // connect to gain
    SinOsc s => g;
    // change frequency
    freq => s.freq;
    freq * 2.0 => freq;
    // decrement x
    1 -=> x;

    // advance time by 1 second
    1::second => now;
    // disconnect the sinosc
    s =< g;
}
"""))
    Demos.insert(new Demo("basic/adsr", "ADSR", "An ADSR envelope", """SinOsc s => ADSR e => dac;
// set a, d, s, and r
e.set( 10::ms, 8::ms, .5, 500::ms );
// set gain
.5 => s.gain;

// infinite time-loop
while( true )
{
    // choose freq
    Math.random2( 20, 120 ) => Std.mtof => s.freq;

    // key on - start attack
    e.keyOn();
    // advance time by 500 ms
    500::ms => now;
    // key off - start release
    e.keyOff();
    // advance time by 800 ms
    800::ms => now;
}
"""))
)
