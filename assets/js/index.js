const SUBJECT = 'johncoleman83';
const metaData = {};

function makeRepoLink (html_url, full_name) {
  metaData['RepoLink'] = "<a target='_blank' href='" + html_url + "'>" + full_name + '</a>';
}

function makeLicenseLink (license) {
  if (license && license.url && license.name) {
    metaData['License'] = "<a target='_blank' href='" + license.url + "'>" + license.name + '</a>';
  } else {
    metaData['License'] = '';
  }
}

function makeDescription (desc) {
  if (desc) {
    metaData['Description'] = '<p><strong>' + desc + '</strong></p>';
  } else {
    metaData['Description'] = '';
  }
}

function makeDateFormat (date) {
  let dateObj = new Date(date);
  metaData['Date'] = '<p>Updated At: ' + dateObj.toDateString() + '</p>';
}

function makeHomepage (homepage) {
  if (homepage && typeof homepage === "string" && homepage.length > 0) {
    let href = "<a target='_blank' href='" + homepage + "'>" + homepage + '</a>';
    metaData['Homepage'] = '<p>Homepage: ' + href + '</p>';
  } else {
    metaData['Homepage'] = '';
  }
}

function generateTemplate (repo) {
  makeHomepage(repo.homepage);
  makeDateFormat(repo.updated_at);
  makeDateFormat(repo.updated_at);
  makeDescription(repo.description);
  makeRepoLink(repo.html_url, repo.full_name);
  makeLicenseLink(repo.license);

  return [
    '<div class="card-panel grey lighten-4 z-depth-4">',
    '<div class="row valign-wrapper">',
    "<div class='col s12 m6 l3 xl3'>",
    metaData['RepoLink'],
    '<div class="row">',
    "<div class='col s12 m12 l12 xl12'>",
    metaData['Description'],
    metaData['Homepage'],
    metaData['Date'],
    metaData['License'],
    '</div></div></div></div></div>',
  ].join('');
}

function appendRepoToHtml (repo, i) {
  if (i % 4 === 0) {
    $('#repositories').append('<div class="row">');
  }
  let template = generateTemplate(repo);
  $('#repositories').append(template);
  if (i % 4 === 3) {
    $('#repositories').append('</div>');
  }
  i += 1;
}

function loopReposTask (data) {
  let i = 0;
  data.forEach(function (repo) {
    if (repo && repo.id) {
      appendRepoToHtml(repo, i)
      i += 1;
    }
  });
  if (i !== 4) {
    $('#repositories').append('</div>');
  }
}

var getData = (function ($) {
  let ReposUrl = `https://api.github.com/users/${SUBJECT}/repos`
  $.ajax({
    url: ReposUrl,
    type: 'GET',
    success: function (data) {
      loopReposTask(data);
    },
    error: function (data) {
      console.info(data);
    }
  });
})($)
