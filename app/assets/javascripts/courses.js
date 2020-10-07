var elm = document.getElementById("graph");
var modal = M.Modal.init(elm);

// Makes a request for the given assignment's five number summary
function getFNS(id) {
    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
        if (this.readyState == 4) {
            var elm = document.getElementById("graph-loading");

            // Render the graph on a successful request
            if (this.status == 200) {
                elm.innerHTML = this.responseText;

            // Indicate that an error occurred
            } else {
                elm.innerHTML = "An error occurred fetching the data.";
            }
        }
    }
    xhttp.open("GET", `/assignments/${id}/summary`, true);
    xhttp.send();
}

// Register button event for all visible buttons
buttons = document.querySelectorAll(".graph-button");
buttons.forEach(function(elm) {
    // Override each graph button's click event to start an AJAX request
    // This grabs the required IDs from it's data- attributes
    elm.addEventListener("click", function(event) {
        // Read IDs from button that was clicked
        assignment_id = event.target.getAttribute("data-assignment");
        student_id = event.target.getAttribute("data-student");

        // Start AJAX request for summary
        getFNS(assignment_id);
    });
});

// Register event for close button to reset modal's state
elm = document.getElementById("graph-close");
elm.addEventListener("click", function() {
    var elm = document.getElementById("graph-loading");
    elm.innerHTML = "Loading...";
    elm.display = "block";
});