var token = $( 'meta[name="csrf-token"]' ).attr( 'content' );

$.ajaxSetup( {
  beforeSend: function ( xhr ) {
    xhr.setRequestHeader( 'X-CSRF-Token', token );
  }
});

$(() => {
  $(".delete-dialog").click((e) => {
    let cur = e.currentTarget;
    console.log(cur);

    new duDialog(null, 'This action cannot be undone, proceed?', {
      buttons: duDialog.OK_CANCEL,
      okText: 'Proceed',
      callbacks: {
        okClick: function(){
          $.ajax(cur.getAttribute('data-link'), {
            type: 'DELETE'
          });
          // do something
          this.hide();  // hides the dialog
        }
      }
    });
  });
});

// initializes the dialog with no title/header, and OK (display text is 'Proceed') and CANCEL buttons;
// with a callback function on OK button click
