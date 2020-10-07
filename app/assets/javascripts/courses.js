var elm = document.getElementById("graph");
var modal = M.Modal.init(elm);

// Register button event for all visible buttons
buttons = document.querySelectorAll(".graph-button");
buttons.forEach(function(elm) {
    // Override each graph button's click event to start an AJAX request
    // This grabs the required IDs from it's data- attributes
    elm.addEventListener("click", function(event) {
        // Read IDs from button that was clicked
        assignment_id = event.target.getAttribute("data-assignment");
        student_id = event.target.getAttribute("data-student");

        // Set matching text (just for now)
        document.getElementById("graph-id1").innerHTML = assignment_id;
        document.getElementById("graph-id2").innerHTML = student_id;
    });
});