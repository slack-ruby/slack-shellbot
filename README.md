# Slack-Shellbot

[![Add to Slack](https://platform.slack-edge.com/img/add_to_slack.png)](http://shell.playplay.io)

[![lint](https://github.com/slack-ruby/slack-shellbot/actions/workflows/lint.yml/badge.svg)](https://github.com/slack-ruby/slack-shellbot/actions/workflows/lint.yml)
[![test](https://github.com/slack-ruby/slack-shellbot/actions/workflows/test.yml/badge.svg)](https://github.com/slack-ruby/slack-shellbot/actions/workflows/test.yml)

A shell bot for Slack. A demo is worth a thousand words.

![](public/img/shell.gif)

## Contributing

This bot is built with [slack-ruby-bot-server-events](https://github.com/slack-ruby/slack-ruby-bot-server-events). See [CONTRIBUTING](CONTRIBUTING.md).

## Website artwork

The website follows the shared Slava, Strata, and Strada layout with a terminal-inspired black/charcoal palette (base `#303035`). The editable `public/img/screenshot-background.svg` adapts the shared ribbon artwork and keeps `preserveAspectRatio="none"` on a fixed viewport-sized layer so expanding help does not resize the background. Preserve the original transparent `public/img/icon.png` terminal logo, its matching multi-resolution favicon, and the original `public/img/shell.gif` demonstration when updating the design.

The bot recommendations use local copies of the original logos: `bot-slava.png` and `bot-strada.png` from their respective projects' `public/img/icon.png`, `bot-gamebot.png` from slack-gamebot2's `public/img/game.png`, and `bot-sup.png` from slack-sup2's `public/img/icon.png`. Preserve their original colors rather than applying the Shell website's monochrome styling.

## Copyright and License

Copyright (c) 2016-2025, Daniel Doubrovkine, Artsy and [Contributors](CHANGELOG.md).

This project is licensed under the [MIT License](LICENSE.md).
