const SUBJECT = 'johncoleman83'

function generateTemplate (r) {
  return [
    "<div class='col-md-3 col-xs-6 col-lg-3' id='repository'><div class='container-fluid'>",
    "<a class='thumbnail' target='_blank' href='" + r.html_url + "'>",
    r.full_name,
    '</a>',
    "<div class='caption'>",
      '<strong>' + r.description + '</strong>',
      '<p> Languages: ' + getLanguages(r.languages_url) + '</p>',
    '</div></div></div>',
  ].join();
}

function getLanguages (url) {
  return "None";
}

var getData = (function ($) {
  let repos = []
  let ReposUrl = `https://api.github.com/users/${SUBJECT}/repos`

  $.ajax({
    url: ReposUrl,
    type: 'GET',
    success: function (data) {
      data.forEach(function (r) {
        if (!r || !r.id) {
          return true
        }
  
        let template = generateTemplate(r);
  
        $('#repositories').append(template)
        repos.push(r.html_url)
      });
    },
    error: function (data) {
      console.info(data);
    }
  });
})($)
