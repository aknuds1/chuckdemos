class Demo
  constructor: (@path, @name, @description, @code, @hasSound=true, @args=[]) ->
    @isOfficial = !_.startsWith(@path, "contrib")

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
  Demos.insert(new Demo("basic/args", "Args", "shows getting command line arguments.",
    """// print number of args
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
  Demos.insert(new Demo("basic/envelope", "Envelope", "Run white noise through envelope.",
    """// run white noise through envelope
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
  Demos.insert(new Demo("basic/fm", "FM", "FM synthesis by hand.", """// carrier
SinOsc c => dac;
// modulator
SinOsc m => blackhole;

// carrier frequency
220 => float cf;
// modulator frequency
550 => float mf => m.freq;
// index of modulation
200 => float index;

// time-loop
while( true )
{
  // modulate
  cf + (index * m.last()) => c.freq;
  // advance time by 1 samp
  1::samp => now;
}
"""))
  Demos.insert(new Demo("basic/fm2", "FM2", "Basic FM synthesis using sinosc.", """// modulator to carrier
SinOsc m => SinOsc c => dac;

// carrier frequency
220 => c.freq;
// modulator frequency
20 => m.freq;
// index of modulation
200 => m.gain;

// phase modulation is FM synthesis (sync is 2)
2 => c.sync;

// time-loop
while( true ) 1::second => now;
"""))
  Demos.insert(new Demo("basic/fm3", "FM3", "Actual FM using sinosc (sync is 0). (Note: this is not quite
   the classic \"FM synthesis\"; also see FM2)", """// modulator to carrier
SinOsc m => SinOsc c => dac;

// carrier frequency
220 => c.freq;
// modulator frequency
20 => m.freq;
// index of modulation
200 => m.gain;

// time-loop
while( true ) 1::second => now;
"""))
  Demos.insert(new Demo("basic/foo", "Foo", "Hello everyone. A chuck is born... Its first words:",
    """SinOsc s => JCRev r => dac;
.2 => s.gain;
.1 => r.mix;

// an array
[ 0, 2, 4, 7, 9, 11 ] @=> int hi[];

while( true )
{
  Std.mtof( 45 + Math.random2(0,3) * 12 +
      hi[Math.random2(0,hi.cap()-1)] ) => s.freq;
  100::ms => now;
}
"""))
  Demos.insert(new Demo("basic/larry", "Larry", "One out of three Stooges.", """// impulse to filter to dac
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
  Std.fabs(Math.sin(v)) * 4000.0 => f.pfreq;
  // increment v
  v + .1 => v;
  // advance time
  99::ms => now;
}
"""))
  Demos.insert(new Demo("basic/moe", "Moe", "One out of three Stooges.", """// impulse to filter to dac
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
  Std.fabs(Math.sin(v)) * 4000.0 => f.pfreq;
  // increment v
  v + .1 => v;
  // advance time
  100::ms => now;
}
"""))
  Demos.insert(new Demo("basic/step", "Step", "Step oscillator.", """// step gen to dac
Step s => dac;
.5 => float v;

// infinite time-loop
while( 1 )
{
  // advance time
  1::ms => now;
  // set value
  v => s.next;
  -v => v;
}
"""))
  Demos.insert(new Demo("basic/imp", "Imp", "Impulse generator is cool... This demo is not.",
    """// connect impulse generator
Impulse i => dac;
.5 => i.gain;

// emit impulse every so often
2000 => int a;
while( 1 )
{
  // set the next sample
  1.0 => i.next;

  // advance time
  a::samp => now;
  a - 8 => a; if( a <= 0 ) 2000 => a;
}
"""))
  Demos.insert(new Demo("basic/unchuck", "Unchuck", "Temporary unchucking of UGen from output.",
    """// noise generator, biquad filter, dac (audio output)
Noise n => BiQuad f => dac;
// set biquad pole radius
.99 => f.prad;
// set biquad gain
.025 => f.gain;
// set equal zeros
1 => f.eqzs;
// our float
0.0 => float t;

3::second + now => time later;
// time-loop
while( now < later )
{
  // sweep the filter resonant frequency
  100.0 + Std.fabs(Math.sin(t)) * 1000.0 => f.pfreq;
  t + .05 => t;
  // advance time
  100::ms => now;
}

// unlink the ugen f from dac
f =< dac;

// let more time pass
3::second => now;

// relink
f => dac;

// time-loop
3::second + now => later;
while( now < later )
{
  // resume sweep
  100.0 + Std.fabs(Math.sin(t)) * 1000.0 => f.pfreq;
  t + .05 => t;
  // advance time
  100::ms => now;
}
"""))
  Demos.insert(new Demo("basic/whole", "Whole", "Another candidate for lamest demo.", """// patch
SinOsc s => JCRev r => dac;
.5 => r.gain;
.075 => r.mix;

// note number
20 => float note;

// go up to 127
while( note < 128 )
{
  // convert MIDI note to hz
  Std.mtof( note ) => s.freq;
  // turn down the volume gradually
  .5 - (note/256.0) => s.gain;

  // move up by whole step
  note + 2 => note;

  // advance time
  .125::second => now;
}

// turn off s
0 => s.gain;
// wait a bit
2::second => now;
"""))
  Demos.insert(new Demo("basic/wind", "Wind", "It's windy...",
    """// noise generator, biquad filter, dac (audio output)
Noise n => BiQuad f => dac;
// set biquad pole radius
.99 => f.prad;
// set biquad gain
.05 => f.gain;
// set equal zeros
1 => f.eqzs;
// our float
0.0 => float t;

// infinite time-loop
while( true )
{
  // sweep the filter resonant frequency
  100.0 + Std.fabs(Math.sin(t)) * 15000.0 => f.pfreq;
  t + .01 => t;
  // advance time
  5::ms => now;
}
"""))
  Demos.insert(new Demo("contrib/risset", "Risset Harmonic Arpeggio",
    "Random Bitz' implementation of Jean-Claude Risset's harmonic arpeggio.",
    """fun void makeTable(float root, float partials[], float amps[], ADSR env, NRev rev, Pan2 pan)
{
SinOsc s[partials.size()];

for (0 => int j; j < partials.size(); 1 +=> j)
{
    Math.random2f(0.1,0.5) => rev.mix;
    Math.random2f(-1.0,1.0) => pan.pan;
    root*partials[j] => s[j].freq;
    amps[j] => s[j].gain;
    s[j] => env;
}
}

fun void risset(float delta, float root, float partials[], float amps[], float duration)
{
  ADSR env => NRev rev => Pan2 pan => dac;
  ( 3::second, 100::ms, .5, 3::second ) => env.set;

  makeTable(root, partials, amps, env, rev, pan);

  for (1 => int i; i <= 4; 1 +=> i)
  {
      makeTable(root+(delta*i), partials, amps, env, rev, pan);
      makeTable(root-(delta*i), partials, amps, env, rev, pan);
  }

  env.keyOn();
  duration::second => now;
  env.keyOff();
  2::second => now;
  pan =< dac;
}

fun void mongol()
{
  [1.0,5.0,6.0,7.0,8.0,9.0,10.0] @=> float partials[];
  [.04,.02,.02,.02,.02,.02,.02] @=> float amps[];
  risset(.03, 100.0, partials, amps, 10);
}

mongol();

fun void fullharm()
{
  [1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0,9.0,10.0,11.0,12.0,13.0,14.0,15.0,16.0] @=> float partials1[];
  [.02,.02,.02,.02,.02,.02,.02,.02,.02,.02,.02,.02,.02,.02,.02,.02] @=> float amps1[];
  risset(.03, 100.0, partials1, amps1, 10);
}

fullharm();

fun void perfect3()
{
  [4.0,5.0,6.0] @=> float partials2[];
  [.05,.05,.05] @=> float amps2[];
  risset(.03, 100.0, partials2, amps2, 10);
}

perfect3();

fun void natscale()
{
  [8.0,9.0,10.0,11.0,12.0,13.0,15.0,16.0] @=> float partials3[];
  [.04,.04,.04,.04,.04,.04,.04,.04] @=> float amps3[];
  risset(.03, 100.0, partials3, amps3, 10);
}

natscale();

fun void fibo()
{
  [1.0,3.0,5.0,8.0,13.0,21.0,34.0] @=> float partials[];
  [.04,.02,.02,.02,.02,.02,.02] @=> float amps[];
  risset(.03, 100.0, partials, amps, 10);
}

fibo();

fun void inharm()
{
  [1.3,3.2,4.5,8.2,11.8,12.7,13.4] @=> float partials[];
  [.04,.02,.02,.02,.02,.02,.02] @=> float amps[];
  risset(.03, 100.0, partials, amps, 15);
}

inharm();
"""))
  Demos.insert(new Demo("contrib/tintinnabuli", "Tintinnabuli",
    "A simple demonstration of Arvo Pärt's algorithmic Tintinnabuli composition technique, made by
    Arve Knudsen in collaboration with Guy Birkin.",
    """NRev rev => dac;
Blit m;
m => rev;
.4 => m.gain;
.1 => rev.mix;

Gain tScalerL => rev;
0.25 => tScalerL.gain;
Pan2 negPan2;
-1. => negPan2.pan;
negPan2 => tScalerL;
Pan2 negPan1;
-.5 => negPan1.pan;
negPan1 => tScalerL;
Pan2 posPan1;
.5 => posPan1.pan;
posPan1 => tScalerL;
Pan2 posPan2;
1. => posPan2.pan;
posPan2 => tScalerL;
Blit tNeg2 => negPan2;
Blit tNeg1 => negPan1;
Blit tPos1 => posPan1;
Blit tPos2 => posPan2;

// A minor scale
[220.0, 246.94, 261.63, 293.66, 329.63, 349.23, 392.0] @=> float scale[];
[130.81, 164.81, 261.63, 329.63] @=> float tPitch0[];
[164.81, 220.0, 261.63, 329.63] @=> float tPitch1[];
[164.81, 220.0, 329.63, 440.0] @=> float tPitch2[];
[220.0, 261.63, 329.63, 440.0] @=> float tPitch3[];
[220.0, 261.63, 440.0, 523.25] @=> float tPitch4[];
[261.63, 329.63, 440.0, 523.25] @=> float tPitch5[];
[261.63, 329.63, 440.0, 523.25] @=> float tPitch6[];

fun void configureVoice(Blit voice, int enable)
{
  1 => voice.harmonics;
  if (enable)
  {
    1.0 => voice.gain;
  }
  else
  {
    0 => voice.gain;
  }
}

fun void setPitch(Blit voice, int note, int number)
{
  if (note == 0)
    tPitch0[number] => voice.freq;
  else if (note == 1)
    tPitch1[number] => voice.freq;
  else if (note == 2)
    tPitch2[number] => voice.freq;
  else if (note == 3)
    tPitch3[number] => voice.freq;
  else if (note == 4)
    tPitch4[number] => voice.freq;
  else if (note == 5)
    tPitch5[number] => voice.freq;
  else if (note == 6)
    tPitch6[number] => voice.freq;
}

fun void sequence(int enableTNeg2, int enableTNeg1, int enableTPos1, int enableTPos2)
{
  configureVoice(tNeg2, enableTNeg2);
  configureVoice(tNeg1, enableTNeg1);
  configureVoice(tPos1, enableTPos1);
  configureVoice(tPos2, enableTPos2);

  for (0 => int i; i < scale.cap(); ++i)
  {
    setPitch(tNeg2, i, 0);
    setPitch(tNeg1, i, 1);
    setPitch(tPos1, i, 2);
    setPitch(tPos2, i, 3);

    scale[i] => m.freq;
    Math.random2(1, 5) => m.harmonics;

    158::ms => now;
  }
}

<<<"No T voices">>>;
sequence(false, false, false, false);

while (true)
{
  <<<"T+1 enabled">>>;
  sequence(false, false, true, false);
  <<<"T+2 enabled">>>;
  sequence(false, false, false, true);
  <<<"T-1 enabled">>>;
  sequence(false, true, false, false);
  <<<"T-2 enabled">>>;
  sequence(true, false, false, false);
  <<<"T+1,T+2 enabled">>>;
  sequence(false, false, true, true);
  <<<"T-1,T+1 enabled">>>;
  sequence(false, true, true, false);
  <<<"T-2,T+1 enabled">>>;
  sequence(true, false, true, false);
  <<<"T-1,T+2 enabled">>>;
  sequence(false, true, false, true);
  <<<"T-2,T-1 enabled">>>;
  sequence(true, true, false, false);
  <<<"T-2,T+2 enabled">>>;
  sequence(true, false, false, true);
  <<<"T-1,T+1,T+2 enabled">>>;
  sequence(false, true, true, true);
  <<<"T-2,T+1,T+2 enabled">>>;
  sequence(true, false, true, true);
  <<<"T-2,T-1,T+1 enabled">>>;
  sequence(true, true, true, false);
  <<<"T-2,T-1,T+2 enabled">>>;
  sequence(true, true, false, true);
  <<<"T-2,T-1,T+1,T+2 enabled">>>;
  sequence(true, true, true, true);
}
"""))
)
