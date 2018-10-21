const SUBJECT = 'johncoleman83'

function generateTemplate (r) {
  return [
    '<div class="card-panel grey lighten-4 z-depth-4">',
    '<div class="row valign-wrapper">',
    "<div class='col s12 m6 l3 xl3'>",
    "<a target='_blank' href='" + r.html_url + "'>",
    r.full_name,
    '</a>',
    '<div class="row">',
    "<div class='col s12 m12 l12 xl12'>",
      '<p><strong>' + r.description + '</strong></p>',
      getHomepage(r),
      '<p>Languages: ' + getLanguages(r.languages_url) + '</p>',
      '<p>Updated At: ' + getDateFormat(r.updated_at) + '</p>',
    '</div></div></div></div></div>',
  ].join('');
}

function getDateFormat(date) {
  let dateObj = new Date(date);
  return dateObj.toDateString();
}

function getHomepage (repo) {
  if (repo.homepage && typeof repo.homepage === "string" && repo.homepage.length > 0) {
    let href = "<a target='_blank' href='" + repo.homepage + "'>" + repo.homepage + '</a>';
    return '<p>Homepage: ' + href + '</p>';
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
      let i = 0;
      data.forEach(function (r) {
        if (!r || !r.id) {
          return true
        }
  
        let template = generateTemplate(r);
        if (i % 4 == 0) {
          $('#repositories').append(
            '<div class="row">' + template + '</div>'
          );
        } else {
          $('#repositories').append(template);
        }
        repos.push(r.html_url)
        i += 1;
      });
    },
    error: function (data) {
      console.info(data);
    }
  });
})($)
