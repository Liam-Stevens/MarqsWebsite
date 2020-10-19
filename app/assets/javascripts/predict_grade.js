$(() => {
  $(".predict-grade-div").click((e) => {
    let cur = e.currentTarget;
    let gradeTag = $(cur).find(".predict-grade")
    
    if (gradeTag.is('p')) {
      let inputTag = $('<input></input>')
        .attr('type', 'number')
        .addClass('predict-grade')
        .val(gradeTag.val())
        .focusout(replaceInputBox)
        .keypress(onEnter);


      gradeTag.replaceWith(inputTag);
      inputTag.focus();
    }
  });

  $('.tooltipped').tooltip();
});


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
  } else if (num < 0.64) {
    return 'P';
  } else if (num < 0.75) {
    return 'C';
  } else if (num < 0.84) {
    return 'D';
  } else {
    return 'HD';
  }
}
