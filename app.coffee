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
  constructor: (@path, @name, @description, @code, @hasSound=true, @args=[]) ->

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
""", false))
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
""", false))
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
    Demos.insert(new Demo("basic/args", "Args", "shows getting command line arguments.", """// print number of args
<<< "number of arguments:", me.args() >>>;

// print each
for( int i; i < me.args(); i++ )
{
    <<< "   ", me.arg(i) >>>;
}
""", false, ["1", "2", "foo"]))
    Demos.insert(new Demo("basic/bar", "Bar", "Point of attack for random otf demo", """SinOsc s => dac;
.2 => s.gain;

// an array: add stuff
[ 0 ] @=> int hi[];

while( true )
{
    // change parameters here
    Std.mtof( 45 + Math.random2(0,0) * 12 +
        hi[Math.random2(0,hi.cap()-1)] ) => s.freq;

    // different rate
    200::ms => now;
}
"""))
    Demos.insert(new Demo("basic/blit", "Blit", "Demonstrates Blit UGen.", """// patch
Blit s => JCRev r => dac;
.5 => s.gain;
.05 => r.mix;

// an array
[ 0, 2, 4, 7, 9, 11 ] @=> int hi[];
// <<< hi.size(), hi.cap() >>>;
// <<< hi[0], hi[1], hi[2], hi[3], hi[4], hi[5] >>>;

// infinite time loop
while( true )
{
    // frequency
    Std.mtof( 33 + Math.random2(0,3) * 12 +
        hi[Math.random2(0,hi.size()-1)] ) => s.freq;

    // harmonics
    Math.random2( 1, 5 ) => s.harmonics;

    // advance time
    120::ms => now;
}
"""))
    Demos.insert(new Demo("basic/blit2", "Blit 2", "Demonstrates Blit UGen with ADSR.", """// patch
Blit s => ADSR e => JCRev r => dac;
.5 => s.gain;
.05 => r.mix;

// set adsr
e.set( 5::ms, 3::ms, .5, 5::ms );

// an array
[ 0, 2, 4, 7, 9, 11 ] @=> int hi[];

// infinite time loop
while( true )
{
    // frequency
    Std.mtof( 33 + Math.random2(0,3) * 12 +
        hi[Math.random2(0,hi.cap()-1)] ) => s.freq;

    // harmonics
    Math.random2( 1, 5 ) => s.harmonics;

    // key on
    e.keyOn();
    // advance time
    120::ms => now;
    // key off
    e.keyOff();
    // advance time
    5::ms => now;
}
"""))
    Demos.insert(new Demo("basic/chirp", "Chirp", "Po-tweet!", """// patch
SinOsc s => dac;
// gain
.4 => s.gain;

// call chirp
chirp( 127, 20, 1::second );

// call chirp (with tinc)
chirp( 20, 120, 1.5::second, 100::ms );

// chirp function
fun void chirp( float src, float target, dur duration )
{
    chirp( src, target, duration, 1::ms );
}

// chirp function (with tinc)
fun void chirp( float src, float target, dur duration, dur tinc )
{
    // initialize freq
    src => float freq;
    // find the number of steps
    duration / tinc => float steps;
    // find the inc
    ( target - src ) / steps => float inc;
    // counter
    float count;

    // do the actual work over time
    while( count < steps )
    {
        // increment the freq
        freq + inc => freq;
        // count
        1 +=> count;

        // set the freq
        Std.mtof( freq ) => s.freq;

        // advance time
        tinc => now;
    }
}
"""))
    Demos.insert(new Demo("basic/chirp2", "Chirp 2", "More chirping...", """// patch
SinOsc s => Envelope e => Pan2 p => dac;
// gain
.5 => s.gain;

// pan hard left
-1 => p.pan;
// call chirp
chirp( 127, 20, 1::second );

// wait for envelope to go down
10::ms => now;
// pan hard right
1 => p.pan;
// call chirp
chirp( 20, 120, 1::second, 100::ms );

// wait a second
1::second => now;

// randomize pan
Math.random2f( -1, 1 ) => p.pan;
// call chirp
chirp( 30, 110, .5::second );

// wait for envelope to go down
10::ms => now;
// pan
Math.random2f( -1, 1 ) => p.pan;
// call chirp
chirp( 110, 30, 1::second, 100::ms );

// wait a second
1::second => now;

// chirp function
fun void chirp( float src, float target, dur duration )
{
    // just call the other one with default tinc
    chirp( src, target, duration, 1::ms );
}

// chirp function (with tinc)
fun void chirp( float src, float target, dur duration, dur tinc )
{
    // initialize freq
    src => float freq;
    // find the number of steps
    duration / tinc => float steps;
    // find the inc
    ( target - src ) / steps => float inc;
    // counter
    float count;
    // set env
    .01 * duration / second => e.time;
    // open env
    1 => e.keyOn;

    // do the actual work over time
    while( count < steps )
    {
        // increment the freq
        freq + inc => freq;
        // count
        1 +=> count;

        // set the freq
        Std.mtof( freq ) => s.freq;

        // advance time
        tinc => now;
    }

    // close env
    1 => e.keyOff;
}
"""))

    Demos.insert(new Demo("basic/comb", "Comb", "A simple comb filter.", """// feedforward
Impulse imp => Gain out => dac;
// feedback
out => Delay delay => out;

// our radius
.99999 => float R;
// our delay order
500 => float L;
// set delay
L::samp => delay.delay;
// set dissipation factor
Math.pow( R, L ) => delay.gain;

// fire impulse
1 => imp.next;

// advance time
(Math.log(.0001) / Math.log(R))::samp => now;
"""))

    Demos.insert(new Demo("basic/curly", "Curly", "One out of three stooges.", """// impulse to filter to dac
Impulse i => BiQuad f => dac;
// set the filter's pole radius
.99 => f.prad;
// set equal gain zeros
1 => f.eqzs;
// initialize float variable
0.0 => float v;
// set filter gain
.5 => f.gain;

// infinite time-loop
while( true )
{
    // set the current sample/impulse
    1.0 => i.next;
    // sweep the filter resonant frequency
    Std.fabs(Math.sin(v)) * 800.0 => f.pfreq;
    // increment v
    v + .1 => v;
    // advance time
    101::ms => now;
}
"""))

    Demos.insert(new Demo("basic/envelope", "Envelope", "Run white noise through envelope.", """// run white noise through envelope
Noise n => Envelope e => dac;

// infinite time-loop
while( true )
{
    // random choose rise/fall time
    Math.random2f(10,500)::ms => dur t => e.duration;
    // print
    <<< "rise/fall:", t/ms, "ms" >>>;

    // key on - start attack
    e.keyOn();
    // advance time by 800 ms
    800::ms => now;
    // key off - start release
    e.keyOff();
    // advance time by 800 ms
    800::ms => now;
}
"""))
)
