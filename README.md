# esvm-snapshot-builder

A build script regularly run by Jenkins to produce the snapshot builds that Kibana uses for testing and development

## environment vars

`./build.sh` looks for a couple environment variables for configuration

<dl>
  <dt><code>ES_REMOTE</code></dt>
  <dd>the git remote to clone for building</dd>
  
  <dt><code>ES_BRANCH</code></dt>
  <dd>the remote branch to build, produces <code>target/$ES_BRANCH.zip</code> and <code>target/$ES_BRANCH.tar.gz</code> files</dd>
</dl>
