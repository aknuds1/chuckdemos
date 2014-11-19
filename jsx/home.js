var Home = React.createClass({
  render: function() {
    return (
      <div>
        <h1>Welcome Home!</h1>
        <this.props.activeRouteHandler/>
      </div>
    );
  }
});
