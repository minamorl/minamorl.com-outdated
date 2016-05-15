import frontmatter
from flask import Flask
import glob
from redisorm import Model, Client, Column

app = Flask()
p = Client("minamorl.com")

class Article(Model):
    id = Column()
    title = Column()
    title_en = Column()
    timestamp = Column()
    content = Column()


def import_to_redis():
    for f in glob.glob("articles/*"):
        post = frontmatter.load(f)
        article = Article()
        article.content = post.content
        article.timestamp = post["timestamp"]
        article.title = post["title"]
        article.title_en = f[len("articles/"):]
        p.save(article)
        
@app.route("/articles/{article_name}.html")
def articles_redirect(article_name):
    



def main():
    app.run(debug=True)

if __name__ == '__main__':
    main()
