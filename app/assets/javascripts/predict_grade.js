$(() => {
  $(".predict-grade-div").click((e) => {
    let cur = e.currentTarget;
    let gradeTag = $(cur).find(".predict-grade")

    if (gradeTag.is('p')) {
      let inputTag = $('<input></input>')
        .addClass('predict-grade')
        .val(gradeTag.val())
        .focusout(replaceInputBox)
        .keypress(onEnter)
        .on("input", function(e) {
          //If it's ok then save previous value
          if (/^\d*\.?\d*$/.test(this.value)) {
            this.prev = this.value;
          
          //If it doesn't match then stay at prev
          } else if (this.hasOwnProperty("prev")) {
            M.toast({html: 'Grades must be a non-negative number'});
            this.value = this.prev;

          //If prev doesn't exist
          } else {
            M.toast({html: 'Grades must be a non-negative number'});
            this.value = "";
          }
        });

      
      gradeTag.replaceWith(inputTag);
      inputTag.focus();
    }
  });

  $('.tooltipped').tooltip();
});


//Replaces input box
function replaceInputBox(e) {
  let cur = $(e.currentTarget)

  let normalTag = $("<p></p>")
    .addClass('calculate-grade')
    .addClass('predict-grade')
    .attr('style', 'color: green;')
    .text(cur.val() || 0);

  cur.replaceWith(normalTag);
  calcAll();
}

function onEnter(e) {
  if (e.which == 13) {
    e.currentTarget.blur();
  }
}

function calcAll() {
  let rows = $(".assignment-row")
    .has(".calculate-grade")

  let percentage = 0;
  let fullWeighting = 0
  rows.each((i) => {
    let cur = $(rows[i])
    fullWeighting += $(cur).find(".weighting").val()/100
  });

  rows.each((i) => {
    let cur = $(rows[i])
    percentage += (($(cur).find(".weighting").val()/100)/fullWeighting)*(parseInt(cur.find(".predict-grade").text())/parseInt(cur.find(".predict-grade-max-points").text()))
  });

  $('#grade_tag').text( (percentage*100).toFixed(2) + "% " + getLetterGrade(percentage));
}

function getLetterGrade(num) {
  if (num < 0.5) {
    return 'F';
  } else if (num < 0.65) {
    return 'P';
  } else if (num < 0.75) {
    return 'C';
  } else if (num < 0.85) {
    return 'D';
  } else {
    return 'HD';
  }
}
