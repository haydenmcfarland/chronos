# chronos (Gitlab/Redmine time tracking helper)

![chronos](https://github.com/haydenmcfarland/assets/blob/master/images/chronos.png?raw=true)

# What?

chronos is a simple script that can be executed in a Gitlab scheduled pipeline to parse merge requests for time tracking purposes. Currently, chronos only integrates with Redmine.

# How to setup

Create a personal project in Gitlab and utilize the import project mechanism to create a new repository from this project.
Then create a `.gitlab-ci.yml` from the provided example:

```
cp .gitlab-ci.yml.example .gitlab-ci.yml
```

I would suggest adding an image and tag a specific runner.

Once you have a valid `.gitlab-ci.yml`, set the following environment variables for the chronos project:

```ruby
GITLAB_API_ACCESS_TOKEN
GITLAB_API_BASE_URL
REDMINE_API_ACCESS_TOKEN
REDMINE_API_BASE_URL
```

Create a Gitlab scheduled pipeline and then run the job manually to test.
It is suggested to run the time tracking job two times during the work day.

# How to use

The following must be done in order for time tracking to be possible:
1. add the redline issue number to a merge request's title or branch name
2. type the special `CHRONOS {hours}` command somewhere in a merge request's description

Example: 

Assume a merge request with branch name: `100925_add_great_feature`
```
@team

- added great feature
- added great feature tests
- formatted files even though I should make that into a separate merge request

CHRONOS 8

NOTE: we may want to do x, y, and z.
```

chronos will create a Redmine time entry associated with issue 100925 for 8 hours with default configuration.
chronos only creates time entries for the current day. 

chronos looks at the merge request's created and update times as well as existing time entries to determine if creating a time entry is necessary.
