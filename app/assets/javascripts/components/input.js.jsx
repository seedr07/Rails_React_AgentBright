var input = React.createClass({

  render: function() {
    return (
      <div className="form-group">
        <label>{this.props.label}</label>
        <input className="form-control" type="text" />
      </div>
    );
  }

});
