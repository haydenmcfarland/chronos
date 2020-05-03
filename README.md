# chronos (Gitlab/Redmine time tracking helper)

![chronos](https://github.com/haydenmcfarland/assets/blob/master/images/chronos.png?raw=true)

# Why?

Lazy.

# What?

chronos is a simple script that can be executed in a Gitlab scheduled pipeline to parse merge requests for time tracking purposes. Currently, chronos only integrates with Redmine.

# How to setup

Create a new repo and import this project as a submodule and then create a `.gitlab-ci.yml` from the provided example:

```
git submodule add --force https://github.com/haydenmcfarland/chronos code
git submodule update --init --force --remote
cp code/.gitlab-ci.yml.example .gitlab-ci.yml
```

Once you have a valid `.gitlab-ci.yml`, set the following environment variables for the chronos project:

```ruby
GITLAB_API_ACCESS_TOKEN
GITLAB_API_BASE_URL
REDMINE_API_ACCESS_TOKEN
REDMINE_API_BASE_URL
```

![environment variables](https://github.com/haydenmcfarland/assets/blob/master/images/chronos_env_example.png?raw=true)

Create a Gitlab scheduled pipeline and then run the job manually to test.
It is suggested to run the time tracking job two times during the work day.

![scheduled job](https://github.com/haydenmcfarland/assets/blob/master/images/chronos_scheduled_job_example.png?raw=true)

Create a ruby script that loads the submodule code, loads credentials, and calls the service:

```ruby
require_relative 'code/chronos.rb'

Chronos::Configuration.load_credentials
Chronos::Gitlab.load_credentials
Chronos::CreateTimeEntries.call

```
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
