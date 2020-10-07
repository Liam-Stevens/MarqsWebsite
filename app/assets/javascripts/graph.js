// Init modal
var elm = document.getElementById("graph");
M.Modal._count = 0;
var modal = M.Modal.init(elm, {
    onOpenStart: function() {
        var elm = document.getElementById("graph-loading");
        elm.innerHTML = "Loading...";
        elm.style.display = "block";
        document.getElementById("graph-container").innerHTML = "";
        document.getElementById("graph-stats").innerHTML = "";
    }
});

// Small helper to return the percentage + grade of a mark
function getGradeString(mark, max_mark) {
    var per = 100.0 * (mark/max_mark);
    var str = `${mark} (${per.toFixed(0)}% `;

    if (per >= 0 && per < 50) {
        str += "F";
    } else if (per >= 50 && per < 64) {
        str += "P";
    } else if (per >= 65 && per < 74) {
        str += "C";
    } else if (per >= 75 && per < 84) {
        str += "D";
    } else if (per >= 85 && per <= 100) {
        str += "HD";
    }

    str += ")";
    return str;
}

// Creates a boxplot svg and inserts in the #graph-container element
function createGraph(json, student_mark) {
    // Calculate graph size
    var container = document.getElementById("graph-container");
    var dim = container.getBoundingClientRect();
    dim.height = 160;
    dim.boxHeight = 60;
    dim.offset = 25;

    // Create graph
    var svg = d3.select("#graph-container")
                .append("svg")
                    .attr("width", dim.width)
                    .attr("height", dim.height)

    // Show X axis
    var x = d3.scaleLinear()
              .range([0, dim.width - (dim.offset*2)])
              .domain([0, json.max_marks])
              .nice()

    var axis = d3.axisBottom(x)
                 .tickValues(x.ticks(6).concat(x.domain()))

    svg.append("g")
        .style("font", "14px times")
        .attr("transform", `translate(${dim.offset}, ${dim.height - 25})`)
        .call(axis)
        .select(".domain").remove()

    // Draw horizontal line of plot
    svg.append("line")
       .attr("x1", x(json.min) + dim.offset)
       .attr("x2", x(json.max) + dim.offset)
       .attr("y1", dim.height/2 - dim.offset/2)
       .attr("y2", dim.height/2 - dim.offset/2)
       .attr("stroke", "#f48fb1")
       .style("width", 40)

    // Draw box
    svg.append("rect")
       .attr("x", x(json.q1) + dim.offset)
       .attr("y", (dim.height - dim.boxHeight - dim.offset)/2)
       .attr("height", dim.boxHeight)
       .attr("width", (x(json.q3) - x(json.q1)))
       .attr("stroke", "#f48fb1")
       .style("fill", "#fce4ec")

    // Draw min, med and max lines
    svg.selectAll("toto")
       .data([json.min, json.med, json.max])
       .enter()
       .append("line")
            .attr("x1", function(v) {
                return (x(v) + dim.offset)
            })
            .attr("x2", function(v) {
                return (x(v) + dim.offset)
            })
            .attr("y1", (dim.height - dim.boxHeight - dim.offset)/2)
            .attr("y2", (dim.height + dim.boxHeight - dim.offset)/2)
            .attr("stroke", "#f48fb1")

    // Finally show the student's marks
    if (student_mark > 0) {
        markSize = dim.boxHeight/3;
        svg.append("rect")
           .attr("x", x(student_mark) + dim.offset - markSize/2)
           .attr("y", (dim.height - markSize - dim.offset)/2)
           .attr("height", markSize)
           .attr("width", markSize)
           .attr("stroke", "#ec407a")
           .style("fill", "#f48fb1")
    }
}

// Makes a request for the given assignment's five number summary
function getFNS(id, mark) {
    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
        if (this.readyState == 4) {
            var elm = document.getElementById("graph-loading");

            // Render the graph on a successful request
            if (this.status == 200) {
                var json = JSON.parse(this.responseText);

                // Show message if returned JSON is empty
                if (JSON.stringify(json) == "{}") {
                    elm.innerHTML = "No grades have been submitted for this assignment."
                    return;
                }

                // Otherwise actually create graph
                elm.style.display = "none"
                createGraph(json, mark);
                document.getElementById("graph-stats").innerHTML = `Average Mark: \t${getGradeString(json.med, json.max_marks)}\n<b>Your Mark: \t\t${getGradeString(mark, json.max_marks)}</b>`;

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
    elm.addEventListener("click", function(event) {
        // Read values from button that was clicked
        assignment_id = event.target.getAttribute("data-assignment");
        assignment_title = event.target.getAttribute("data-title");
        student_mark = event.target.getAttribute("data-student");

        // Start AJAX request for summary
        document.getElementById("graph-heading").innerHTML = "Mark Boxplot for: " + assignment_title;
        getFNS(assignment_id, student_mark);
    });
});