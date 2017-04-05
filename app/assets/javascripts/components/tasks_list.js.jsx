var TasksList = React.createClass({
  getInitialState: function() {
    return {
      tasks: this.props.initialTasks,
    };
  },

  render: function() {
    var tasks = this.state.tasks.map(function(task) {
      return <Task key={task.id} task={task} />;
    });

    return (
      <div className="tasks">
        {tasks}
      </div>
    );
  }

});
