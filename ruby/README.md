References:
- https://github.com/microsoft/vscode-dev-containers/blob/56f44d2fb0/containers/python-3-postgres
- https://github.com/microsoft/vscode-dev-containers/blob/56f44d2fb0/containers/ruby-2
- https://github.com/microsoft/vscode-dev-containers/blob/56f44d2fb0/containers/ruby-2-rails-5
- https://github.com/CircleCI-Public/circleci-dockerfiles/blob/e256d226ca/ruby/images/2.7.1-buster/browsers/Dockerfile#L41-L59

When there is no default Ruby image from https://hub.docker.com/_/ruby available for the required Ruby version, copy the data from an old Dockerfile instead:
- https://github.com/docker-library/ruby/blob/c387c6c3a2/2.0
- https://github.com/docker-library/ruby/blob/c5693b25aa/2.1
- https://github.com/docker-library/ruby/blob/b5ef401d34/2.2
- https://github.com/docker-library/ruby/blob/31f66490fd/2.3

The Checksum values can be looked up here: https://www.ruby-lang.org/en/downloads/releases/
