# AWS CodeBuild Test

![CodeBuild badge](https://URL-de/to/build/badge)

Some testing to get a CodeBuild running



 + /content/  <---- Webseiten Content hier rein
 + /terraform/  <---- Terraform Code um die AWS Pipeline zu bauen
 + /deployment/ <------ eigentlicher Code zum Hochladen des gewünschten Tags zu AWS


To Update Content and set a time of deployment:
 + Put your updated content into /content/ (remove obsolete files)
 + Git add and push your changes
 + Afterwards add a tag to the current revision, e.g.:
 ++ git tag -a 201904051112-deployme -m "Deployment for 05.04.2019, 11:12"
 + and push the tags:
 ++ git push --tags


Manuelle Schitte:
 + Github Connect
 + Parameter Store -> GithubAccount -> Token
 + bei komplet neuem codebuild job muss ggf die badge url upgadated werden
