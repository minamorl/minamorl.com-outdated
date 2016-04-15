import frontmatter
from flask import Flask
import glob
from redisorm.core import PersistentData, Persistent, Column

app = Flask()
p = Persistent("minamorl.com")

class Article(PersistentData):
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
        
def main():
    app.run(debug=True)

if __name__ == '__main__':
    main()
