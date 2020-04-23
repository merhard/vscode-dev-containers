FROM elixir

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Configure apt and install packages
RUN apt-get update \
    && apt-get install -y --no-install-recommends apt-utils dialog 2>&1 \
    #
    # Install vim, git, process tools, lsb-release
    && apt-get install -y \
        vim \
        git \
        openssh-client \
        less \
        iproute2 \
        procps \
        lsb-release \
    #
    # Install Phoenix Linux PreReqs
    && apt-get install -y inotify-tools \
    #
    # Install PostgreSQL Client
    && curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -  2>/dev/null \
    && echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
    && apt-get update \
    && apt-get install -y postgresql-client \
    #
    # Install nodejs
    && curl -sL https://deb.nodesource.com/setup_12.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g npm \
    #
    # Setup Mix
    && mix local.hex --force \
    && mix local.rebar --force \
    #
    # Install personal dev environment requirements
    && apt-get install -y \
        zsh \
        silversearcher-ag \
        ruby \
    #
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog
