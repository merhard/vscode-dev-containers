From the app, run:

```bash
cp -R ~/Projects/vscode-app-setting-examples/ruby/devcontainer/ ./.devcontainer
cp -R ~/Projects/vscode-app-setting-examples/ruby/vscode/ ./.vscode
```

These are settings for when there is no default Ruby image (from https://hub.docker.com/_/ruby) available for the needed Ruby version.

```
# Mix of:
#   - https://github.com/docker-library/ruby/blob/c387c6c3a2505060514e31c247cb37d22c944e55/2.0/Dockerfile
#   - https://github.com/microsoft/vscode-dev-containers/blob/3a245e31c83fcbb4dc70c9d796edfc2b12fee459/containers/ruby-2/.devcontainer/Dockerfile
#   - https://github.com/microsoft/vscode-dev-containers/blob/3a245e31c83fcbb4dc70c9d796edfc2b12fee459/containers/ruby-2-rails-5/.devcontainer/Dockerfile
#   - https://github.com/CircleCI-Public/circleci-dockerfiles/blob/e577cd18e2a7a8abfd00b4d36a75fd9c4cfeb4ec/ruby/images/2.7.1-buster/browsers/Dockerfile#L41-L59

FROM buildpack-deps:jessie

ENV RUBY_MAJOR 2.0
ENV RUBY_VERSION 2.0.0-p353
ENV RUBY_DOWNLOAD_SHA256 465afc77d201b5815bb7ce3660a1f5a131f4429a3fa483c126ce66923e4726cc
ENV RUBYGEMS_VERSION 2.6.0
ENV BUNDLER_VERSION 1.17.3

RUN mkdir -p /usr/local/etc \
    && { \
      echo 'install: --no-document'; \
      echo 'update: --no-document'; \
    } >> /usr/local/etc/gemrc

# some of ruby's build scripts are written in ruby
# we purge this later to make sure our final image uses what we just built
RUN set -ex \
    && buildDeps=' \
      bison \
      libgdbm-dev \
      ruby \
    ' \
    && apt-get update \
    && apt-get install -y --no-install-recommends $buildDeps \
    && rm -rf /var/lib/apt/lists/* \
    && curl -fSL -o ruby.tar.gz "http://cache.ruby-lang.org/pub/ruby/$RUBY_MAJOR/ruby-$RUBY_VERSION.tar.gz" \
    && echo "$RUBY_DOWNLOAD_SHA256 *ruby.tar.gz" | sha256sum -c - \
    && mkdir -p /usr/src/ruby \
    && tar -xzf ruby.tar.gz -C /usr/src/ruby --strip-components=1 \
    && rm ruby.tar.gz \
    && cd /usr/src/ruby \
    && { echo '#define ENABLE_PATH_CHECK 0'; echo; cat file.c; } > file.c.new && mv file.c.new file.c \
    && autoconf \
    && ./configure --disable-install-doc \
    && make -j"$(nproc)" \
    && make install \
    && apt-get purge -y --auto-remove $buildDeps \
    && gem update --system $RUBYGEMS_VERSION \
    && rm -r /usr/src/ruby

RUN gem install bundler --version "$BUNDLER_VERSION"

# install things globally, for great justice
# and don't create ".bundle" in all our apps
ENV GEM_HOME /usr/local/bundle
ENV BUNDLE_PATH="$GEM_HOME" \
    BUNDLE_BIN="$GEM_HOME/bin" \
    BUNDLE_SILENCE_ROOT_WARNING=1 \
    BUNDLE_APP_CONFIG="$GEM_HOME"
ENV PATH $BUNDLE_BIN:$PATH
RUN mkdir -p "$GEM_HOME" "$BUNDLE_BIN" \
    && chmod 777 "$GEM_HOME" "$BUNDLE_BIN"
```
