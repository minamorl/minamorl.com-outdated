from plan import shell, run, plan
import os

def rsync():
    return shell("rsync -av dist {}".format(os.environ.get("DEPLOY_TARGET")).split(" "), asynchronous=False)


def git():
    run(["git", "add", "."])
    run(["git", "commit", "-m", "new article"])
    shell(["git", "push"])


@plan("dist")
def plan_dist(args):
    if input("git? ") == "y":
        git()
    shell(["gulp", "deploy"], asynchronous=False)
    rsync()

@plan("a")
def plan_minamorl_article(args):
    if args.args:
        run(["vim", args.args[0] + ".md"], on="~/repos/minamorl.com/articles", start_new_session=True)
    else:
        yield shell(["gulp"], on="~/repos/minamorl.com")
