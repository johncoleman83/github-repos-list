const SUBJECT = 'johncoleman83'

function generateTemplate (r) {
  return [
    "<div class='col s12 m6 l3 xl3'>",
    "<a class='thumbnail' target='_blank' href='" + r.html_url + "'>",
    r.full_name,
    '</a>',
    '<div class="row">',
    "<div class='col s12 m12 l12 xl12'>",
      '<p><strong>' + r.description + '</strong></p>',
      '<p>Languages: ' + getLanguages(r.languages_url) + '</p>',
      '<p>Updated At: ' + r.updated_at + '</p>',
      getWebsite(r),
    '</div></div></div>',
  ].join('');
}

function getWebsite (repo) {
  if (repo.homepage && typeof repo.homepage === "string" && repo.homepage.length > 0) {
    return '<p>Homepage: ' + repo.homepage + '</p>';
  }
  return '';
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
