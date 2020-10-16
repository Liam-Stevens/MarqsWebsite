var elems = document.querySelectorAll('select');
var instances = M.FormSelect.init(elems, {});

document.addEventListener('turbolinks:load', () => {
    elems = document.querySelectorAll('select');
    instances = M.FormSelect.init(elems, {});
})
