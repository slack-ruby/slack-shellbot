### Slack-Shellbot

[![Add to Slack](https://platform.slack-edge.com/img/add_to_slack@2x.png)](http://shell.playplay.io)

## Deploy Your Own Slack-Shellbot

[![Deploy to Heroku](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy?template=https://github.com/slack-ruby/slack-shellbot)

### MongoDB

Deploy slack-shellbot to Heroku and add a MongoLab or Compose MongoDB provider. You can use both free and paid tiers.

### Environment

#### SLACK_API_TOKEN

If your bot services one team, create a new bot integration on Slack and set `SLACK_API_TOKEN` from the bot integration settings on Slack. The first time you start the service it will automatically create a team using this token.

```
heroku config:add SLACK_API_TOKEN=...
```

#### SLACK_CLIENT_ID and SLACK_CLIENT_SECRET

If your bot services mutliple teams, create a new bot app and set `SLACK_CLIENT_ID` and `SLACK_CLIENT_SECRET`.
