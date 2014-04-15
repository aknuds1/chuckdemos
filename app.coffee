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
    SeoCollection.insert(
      route_name: "about"
      title: "About ChucK Demos"
      meta:
        description: "The main purpose of the ChucK Demos site is to provide a repository of ChucK demo
         programs that can also be heard right inside the browser. Its secondary purpose is to showcase the
         ChucKJS JavaScript library, which is made by the site's author."
    )

    Meteor.publish("demos", -> Demos.find())
    Demos.remove({})

    Demos.insert(new Demo("basic/demo0", "Demo 0", "Basic demo showing time and duration.",
      """5::second + now => time later;

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
    Demos.insert(new Demo("basic/alarm", "Alarm", "An alarm clock.", """// how long
10::second => dur T;
// frequency
880 => float f;

// remember
now => time start;
now + T => time later;

// wait
while( now < later )
{
    <<< (T - (now - start)) / second, "left..." >>>;
    1::second => now;
}

// patch
SinOsc s => JCRev r => dac;
.025 => r.mix;
f => s.freq;

// infinite while loop
while( true )
{
    // go
    1.0 => s.gain;
    300::ms => now;
    // stop
    0.0 => s.gain;
    300::ms => now;
}
"""))
)
