jQuery.fn.submitOnCheck = function() {
  this.find("input[type=checkbox]").click(function() {
    $(this).closest(".todo").addClass("busy");
    $(this).closest("form").trigger("submit");
  });
  return this;
};

jQuery.fn.addTaskSectionToID = function(id) {
  var checkbox, label, section, inputID;

  checkbox = $(this).find("input[type=checkbox]");
  label = $(this).find("label");
  section = $(this).closest("article").attr("data-task-section");
  inputID = "task_" + id + "_completed_" + section;

  checkbox.attr("id", inputID);
  label.attr("for", inputID);

  return this;
};

// $("select.abc").toggleFormControls({value: ", target: "#someOtherControl"})
// not yet:
// $("a.toggle").toggleFormControls({source: "#someControl", target: "#someOtherControl"})
jQuery.fn.toggleFormControls = function(options) {
  options || (options = {});
  var self = $(this);
  var target = $(options.target);
  var value = options.value;

  if (typeof value !== "undefined") {
    // I'm a select
    self.on("change init", function(evt) {
      evt.preventDefault();
      evt.stopPropagation();

      var toggle = self.val() === value;
      self.attr("disabled", toggle);
      self.trigger(toggle ? "disable" : "enable");
      target.attr("disabled", !toggle);
      target.trigger(!toggle ? "disable" : "enable");
    });
    self.trigger("init");
  }
};


jQuery.fn.cancelNewTask = function() {
  this.on("click", function() {
    var newTaskForm;
    newTaskForm = $(this).closest("form");
    newTaskForm.prev().show().button("reset");
    newTaskForm.remove();
  });
};

$(document).on("change", "[data-behavior='task-associated'] input:radio", function() {
  if ($(this).val() === "Contact") {
    $("#task_taskable_id_contact").prop("disabled", false);
    $("#task_taskable_id_contact").parents(".select.task_taskable").show();

    $("#task_is_next_action").prop("disabled", true);
    $("#task_is_next_action").parents(".checkbox.below24").hide();

    $("#task_taskable_id_lead").prop("disabled", true);
    $("#task_taskable_id_lead").parents(".select.task_taskable").hide();

    $("#dashboard-new-task-modal-association-type-div").html("<input id='dashboard-new-task-modal-association-type-val' type='hidden' value='Contact' />");
  }

  if ($(this).val() === "Lead/Client") {
    $("#task_taskable_id_lead").prop("disabled", false);
    $("#task_taskable_id_lead").parents(".select.task_taskable").show();

    $("#task_is_next_action").prop("disabled", false);
    $("#task_is_next_action").parents(".checkbox.below24").show();

    $("#task_taskable_id_contact").prop("disabled", true);
    $("#task_taskable_id_contact").parents(".select.task_taskable").hide();

    $("#dashboard-new-task-modal-association-type-div").html("<input id='dashboard-new-task-modal-association-type-val' type='hidden' value='Lead' />");
  }

  if ($(this).val() === "None") {
    $("#task_taskable_id_contact").prop("disabled", true);
    $("#task_taskable_id_lead").prop("disabled", true);

    $("#task_is_next_action").prop("disabled", true);
    $("#task_is_next_action").parents(".checkbox.below24").hide();

    $("#task_taskable_id_contact").parents(".select.task_taskable").hide();
    $("#task_taskable_id_lead").parents(".select.task_taskable").hide();

    $("[data-info='taskable_id']").val("");

    $("#dashboard-new-task-modal-association-type-div").html("<input id='dashboard-new-task-modal-association-type-val' type='hidden' value='None' />");
  }
});

$(document).on("change", ".task_taskable select", function() {
  var taskableId = $(this).val();

  $("[data-info='taskable_id']").val(taskableId);

  $("#dashboard-new-task-modal-association-id-div").html("<input id='dashboard-new-task-modal-association-id-val' type='hidden' value= " + taskableId + " />");
});

document.addEventListener("turbolinks:load", function() {
  var taskID = $("[data-info~=taskable_id]").val();
  var taskType = $('input[name="task[taskable_type]"]:checked').val();

  if (taskType === "Contact") {
    $("#task_taskable_id_contact").val(taskID);
    $("#task_taskable_id_lead").prop("disabled", true);
  }

  if (taskType === "Lead/Client") {
    $("#task_taskable_id_lead").val(taskID);
    $("#task_taskable_id_contact").prop("disabled", true);
  }

  if (taskType === "None") {
    $("#task_taskable_id_lead").prop("disabled", true);
    $("#task_taskable_id_contact").prop("disabled", true);
  }

  $("#task_taskable_id_lead").useSelect2();
  $("#task_taskable_id_contact").useSelect2();

});

document.addEventListener("turbolinks:load", function() {
  $("[data-behavior=submit-on-check]").submitOnCheck();
  $("[data-behavior~=cancel-new-task]").cancelNewTask();
});

$(document).on("click", "[data-behavior='add-task-shortcut']", function() {
  if ($("#new_task").length > 0) {
    var newTaskForm = $("#new_task");
    newTaskForm.prev().show().button("reset");
    newTaskForm.remove();
  }
});
