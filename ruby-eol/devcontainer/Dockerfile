# Mix of:
#   - https://github.com/docker-library/ruby/blob/c387c6c3a2505060514e31c247cb37d22c944e55/2.0/Dockerfile
#   - https://github.com/microsoft/vscode-dev-containers/blob/3a245e31c83fcbb4dc70c9d796edfc2b12fee459/containers/ruby-2/.devcontainer/Dockerfile
#   - https://github.com/microsoft/vscode-dev-containers/blob/3a245e31c83fcbb4dc70c9d796edfc2b12fee459/containers/ruby-2-rails-5/.devcontainer/Dockerfile
#   - https://github.com/CircleCI-Public/circleci-dockerfiles/blob/e577cd18e2a7a8abfd00b4d36a75fd9c4cfeb4ec/ruby/images/2.7.1-buster/browsers/Dockerfile#L41-L59

FROM buildpack-deps:jessie

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

RUN mkdir -p /usr/local/etc \
    && { \
      echo 'install: --no-document'; \
      echo 'update: --no-document'; \
    } >> /usr/local/etc/gemrc

ENV RUBY_MAJOR 2.0
ENV RUBY_VERSION 2.0.0-p353
ENV RUBY_DOWNLOAD_SHA256 465afc77d201b5815bb7ce3660a1f5a131f4429a3fa483c126ce66923e4726cc
ENV RUBYGEMS_VERSION 2.6.0
ENV BUNDLER_VERSION 1.17.3

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

# Configure apt and install packages
RUN apt-get update \
    && apt-get install -y --no-install-recommends apt-utils dialog 2>&1 \
    #
    # Install vim, git, process tools, lsb-release
    && apt-get install -y \
        zsh \
        silversearcher-ag \
        vim \
        git \
        openssh-client \
        less \
        iproute2 \
        procps \
        lsb-release \
    #
    # Install PostgreSQL Client
    && apt-get install -y postgresql-client \
    #
    # Install nodejs
    && curl -sL https://deb.nodesource.com/setup_12.x | bash - \
    && apt-get install -y nodejs \
    # 
    # Install yarn
    && apt-get install -y curl apt-transport-https lsb-release \
    && curl -sS https://dl.yarnpkg.com/$(lsb_release -is | tr '[:upper:]' '[:lower:]')/pubkey.gpg | apt-key add - 2>/dev/null \
    && echo "deb https://dl.yarnpkg.com/$(lsb_release -is | tr '[:upper:]' '[:lower:]')/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get -y install --no-install-recommends yarn \
    #
    # Install debug tools
    && gem install \
        ruby-debug-ide \
        debase \
    #
    # Install chrome for headless testing
    && apt-get install -y libgconf-2-4 \
    && curl --silent --show-error --location --fail --retry 3 --output /tmp/google-chrome-stable_current_amd64.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && (dpkg -i /tmp/google-chrome-stable_current_amd64.deb || apt-get -fy install)  \
    && rm -rf /tmp/google-chrome-stable_current_amd64.deb \
    && sed -i 's|HERE/chrome"|HERE/chrome" --disable-setuid-sandbox --no-sandbox|g' "/opt/google/chrome/google-chrome" \
    && google-chrome --version \
    && CHROME_VERSION="$(google-chrome --version)" \
    && export CHROMEDRIVER_RELEASE="$(echo $CHROME_VERSION | sed 's/^Google Chrome //')" \
    && export CHROMEDRIVER_RELEASE=${CHROMEDRIVER_RELEASE%%.*} \
    && CHROMEDRIVER_VERSION=$(curl --location --fail --retry 3 http://chromedriver.storage.googleapis.com/LATEST_RELEASE_${CHROMEDRIVER_RELEASE}) \
    && curl --silent --show-error --location --fail --retry 3 --output /tmp/chromedriver_linux64.zip "http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip" \
    && cd /tmp \
    && unzip chromedriver_linux64.zip \
    && rm -rf chromedriver_linux64.zip \
    && mv chromedriver /usr/local/bin/chromedriver \
    && chmod +x /usr/local/bin/chromedriver \
    && chromedriver --version \
    #
    # Persist ZSH history between runs
    # - use ~/.zshrc.local so developer can still import their own dotfiles without issue (using VSCode's "dotfiles.repository" setting)
    # - be sure to have `[[ -f "$HOME/.zshrc.local" ]] && source $HOME/.zshrc.local` at the bottom of your personal ~/.zshrc dotfile
    && echo "export HISTFILE=/commandhistory/.zsh_history" >> /root/.zshrc.local \
    #
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog
