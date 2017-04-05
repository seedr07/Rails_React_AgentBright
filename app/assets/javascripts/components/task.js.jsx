var Task = React.createClass({

  render: function() {
    return (
      <div className="task">
        <TaskHeader task={this.props.task} />
        <TaskContent task={this.props.task} />
      </div>
    );
  }

});

var TaskHeader = React.createClass({
  render: function() {
    return (
      <div className="task-header">
        <h2>{this.props.task.subject}</h2>
        <div className="task-meta">
          Due {this.props.task.due_date_at} by {this.props.task.assigned_to_id}
        </div>
      </div>
    );
  }
});

var TaskContent = React.createClass({
  render: function() {
    return (
      <div className="task-contents">
        Was this task completed? {this.props.task.completed}
      </div>
    );
  }
});
