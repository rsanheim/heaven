# Heaven [![Build Status](https://travis-ci.org/atmos/heaven.png?branch=master)](https://travis-ci.org/atmos/heaven)

Heaven is an API that integrates with GitHub's [Deployment API][1]. It receives [deployment events][5] from GitHub and pushes code to your servers.

Heaven currently supports [Capistrano][15], [Fabric][10], and [Heroku][22] deployments. It also has a notification system for broadcasting  [deployment status events][6] to chat services(e.g. [Campfire][7], [Hipchat][8], [SlackHQ][9], and [Flowdock][21]).  It can be hosted on Heroku for a few dollars a month.

# Documentation

* [Overview](/doc/overview.md)
* [Installation](/doc/installation.md)
* [Deployment Providers](/doc/providers.md)
* [Deployment Notifications](/doc/notifications.md)
* [Environment Locking](/doc/locking.md)

## Making changes to our version of Heaven

To make any changes to Heaven, you'll need Docker installed locally.

### Adding rails masterkey

With the change to rails 5, in order to successfully build a docker image, you will need to add a rails masterkey locally. This will only need to be done once.

1. Grab the Heaven rails masterkey from our shared 1password vault
2. run `EDITOR="vim" bin/rails credentials:edit` to edit the master key file and paste in the masterkey you copied from the vault.

### Next steps for making changes

1. make your changes to Heaven and open a pull request.
2. Make sure your CircleCI build is green.
3. Build the new docker image locally in your branch to make sure it works:
`Docker build .`
4. Merge your PR to master.
5. Checkout master and pull.
6. Push your changes to Docker registry using the release script:

```(sh)
cd heaven
script/release
```

7. Then deploy the latest Docker image to our environment:

```(sh)
cd aws-deploy-brainy
script/deploy production heaven -t heaven
```

[1]: http://developer.github.com/v3/repos/deployments/
[2]: https://github.com/blog/1778-webhooks-level-up
[3]: https://github.com/resque/resque
[4]: https://gist.github.com/
[5]: https://developer.github.com/v3/repos/deployments/#create-a-deployment
[6]: https://developer.github.com/v3/repos/deployments/#create-a-deployment-status
[7]: https://campfirenow.com/
[8]: https://www.hipchat.com/
[9]: https://slack.com/
[10]: http://www.fabfile.org/
[11]: http://www.getchef.com/
[12]: http://puppetlabs.com/
[13]: https://devcenter.heroku.com/articles/build-and-release-using-the-api
[14]: https://developer.github.com/v3/repos/contents/#get-archive-link
[15]: http://capistranorb.com/
[16]: https://github.com/settings/applications
[17]: https://devcenter.heroku.com/articles/oauth#direct-authorization
[18]: https://www.phusionpassenger.com/
[19]: https://devcenter.heroku.com/articles/releases
[20]: https://github.com/atmos/hubot-deploy
[21]: https://www.flowdock.com/
[22]: https://www.heroku.com
