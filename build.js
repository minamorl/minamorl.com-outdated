let jade      = require("jade")
let fs        = require("fs")
let yamlFront = require('yaml-front-matter');
let mkdirp    = require('mkdirp');
let marked    = require('marked');
let glob      = require("glob")
let striptags     = require('striptags');
let path   = require("path")

let DIST = "./dist/"

let build = {
  build_articles: () => {
    mkdirp(DIST, function (err) {
      if (err) console.error(err)
    });
    mkdirp(DIST+"articles/", function (err) {
      if (err) console.error(err)
    });
    let defaultLayout = {
      layout: "templates/article.jade",
      striptags: striptags
    };
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
      let parsed = [];
      for (let filename of markdown_filenames) {
        let yaml = yamlFront.loadFront(fs.readFileSync('articles/' + filename));
        parsed.push({
          filename: filename,
          target: "articles/" + yaml.timestamp + "-" + filename.replace('.md', '.html'),
          yaml: yaml,
        });
      }

      let _by_timestamp = (a, b) => {
        if (a.yaml.timestamp < b.yaml.timestamp)
          return 1;
        if (a.yaml.timestamp > b.yaml.timestamp)
          return -1;
        return 0;
      }

      parsed.sort(_by_timestamp);

      let get_comments = (str) => {
        let readmore = /<!--\s*read\s*more\s*-->/i;
        str.match(readmore);
      };

      let get_elements_before_readmore = (str) => {
        let comment = get_comments(str)
        if(comment)
          return str.split(comment[0])[0];
        return str;
      };

      let compiled = jade.compileFile("./templates/index.jade")(
        {
          dir: parsed,
          marked: marked,
          get_comments: get_comments,
          get_elements_before_readmore: get_elements_before_readmore,
        }
      )
      fs.writeFile("./dist/index.html", compiled, function (err) {
        if (err) console.error(err)
      })
    })
  }
}
module.exports = build
