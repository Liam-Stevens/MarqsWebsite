new Tablesort(document.getElementById('table-id'));

// Allows all th with class 'sortable' to have sort arrows on click
function setArrow(e) {
  //Reset all arrows
  $('.sortable-arrow').text("sort")

  let header = e.currentTarget;
  if (header.getAttribute("aria-sort") === "ascending") {
    $(header).find('.sortable-arrow').text("arrow_upward");
  } else {
    $(header).find('.sortable-arrow').text("arrow_downward");
  }
}

$(() => {
  $('.sortable').click(setArrow)
});
