let jade      = require("jade")
let fs        = require("fs")
let yamlFront = require('yaml-front-matter');
let mkdirp    = require('mkdirp');
let marked    = require('marked');
let glob      = require("glob")
let striptags     = require('striptags');
let path   = require("path")
let moment = require("moment")
let RSS = require("rss")

let DIST = "./dist/"

const _by_timestamp = (a, b) => {
  if (a.yaml.timestamp < b.yaml.timestamp)
    return 1;
  if (a.yaml.timestamp > b.yaml.timestamp)
    return -1;
  return 0;
}


const generate_feed = (articles) => {
  let feed = new RSS({
    title: "minamorl.com",
    feed_url: "http://minamorl.com/feed.rss",
    site_url: "minamorl.com",
  })
  
  for (let article of articles) {
    feed.item({
      title: article.yaml.title,
      description: marked(article.yaml.__content),
      date: moment(article.yaml.timestamp),
      url: "http://minamorl.com/" + article.target
    })
  }

  return feed.xml()
}
const build = {
  build_articles: () => {
    mkdirp(DIST, function (err) {
      if (err) console.error(err)
    });
    mkdirp(DIST+"articles/", function (err) {
      if (err) console.error(err)
    });
    glob('./articles/**/*.md', (err, matches) => {
      for (let filename of matches)
        build.build_article(filename)
    })
  },

  build_article: (filename) => {
      fs.readFile(filename, 'utf8', function(err, data){
        if (err) throw err

        let yaml = yamlFront.loadFront(fs.readFileSync(filename))
        let markdown = marked(data, yaml)
        let filepath = yaml.timestamp + "-" + path.basename(filename, ".md") + ".html"
        let compiled = jade.compileFile("./templates/article.jade")(
          {
            yaml: yaml,
            marked: marked,
            contents: markdown,
            striptags: striptags
          }
        )
        fs.writeFile(DIST+"articles/"+filepath, compiled, function (err) {
          if (err) console.error(err)
        })
      })
  },

  build_index: () => {
    mkdirp(DIST, function (err) {
      if (err) console.error(err)
    });

    fs.readdir('articles', (err, markdown_filenames) => {
      let all_articles = [];
      for (let filename of markdown_filenames) {
        const yaml = yamlFront.loadFront(fs.readFileSync('articles/' + filename));
        all_articles.push({
          filename: filename,
          target: "articles/" + yaml.timestamp + "-" + filename.replace('.md', '.html'),
          yaml: yaml,
        })
      }

      all_articles.sort(_by_timestamp)

      const compiled = jade.compileFile("./templates/index.jade")({
        all_articles: all_articles,
        marked: marked,
      })
      fs.writeFile("./dist/index.html", compiled, function (err) {
        if (err) console.error(err)
      })
      /* generate RSS feed */
      fs.writeFile("./dist/feed.rss", generate_feed(all_articles.slice(0, 5)), function (err) {
        if (err) console.error(err)
      })
    })

  }
}
module.exports = build
