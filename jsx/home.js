'use strict'

var Home = React.createClass({
  render: function() {
    return (
      <div className="jumbotron no-btm-margin">
        <h1>ChucK Demos</h1>

        <p>This site collects demonstrations of the <a href="http://chuck.cs.princeton.edu/" target="_blank">
        ChucK</a> music programming language, with the useful ability to play them back in your browser
        (provided that your browser supports
        the <a href="https://developer.mozilla.org/en-US/docs/Web_Audio_API" target="_blank">Web Audio API</a>).
        </p>

        <p>In-browser execution of ChucK programs is made possible by the <a href="https://github.com/aknuds1/chuckjs"
          target="_blank">ChucKJS</a> JavaScript library.
        </p>
      </div>
    );
  }
});
