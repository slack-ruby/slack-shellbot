Slack-Shellbot
=============

[![Add to Slack](https://platform.slack-edge.com/img/add_to_slack@2x.png)](http://shlack.dblock.org)

Or roll your own ...

[![Build Status](https://travis-ci.org/dblock/slack-shellbot.svg)](https://travis-ci.org/dblock/slack-shellbot)
[![Code Climate](https://codeclimate.com/github/dblock/slack-shellbot/badges/gpa.svg)](https://codeclimate.com/github/dblock/slack-shellbot)

A shell bot for Slack.

TODO

## Installation

Create a new Bot Integration under [services/new/bot](http://slack.com/services/new/bot). Note the API token.
You will be able to invoke shellbot by the name you give it in the UI above.

Run `SLACK_API_TOKEN=<your API token> foreman start`

## Production Deployment

See [DEPLOYMENT](DEPLOYMENT.md)

## Contributing

This bot is built with [slack-ruby-bot](https://github.com/dblock/slack-ruby-bot). See [CONTRIBUTING](CONTRIBUTING.md).

## Copyright and License

Copyright (c) 2016, Daniel Doubrovkine, Artsy and [Contributors](CHANGELOG.md).

This project is licensed under the [MIT License](LICENSE.md).
