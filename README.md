# Usage

To add any of these settings to an app, copy the appropriate `devcontainer` and/or `vscode` folders into the root of your app. Be sure to prefix the copied folders with a "`.`" (`devcontainer => .devcontainer`, etc).

Here is an example ZSH command to run if this repo has been cloned to your machine:

```zsh
for dir in ~/Projects/vscode-dev-containers/<LANGUAGE>/*/; do cp -R "$dir" "./.$dir:t"; done
```

# Requirements

(see https://code.visualstudio.com/docs/remote/containers for more information)

- [Docker Desktop](https://www.docker.com/products/docker-desktop)
  - `brew cask install docker`

- [VSCode](https://code.visualstudio.com/)
  - `brew cask install visual-studio-code`

- [VSCode "Remote - Containers" Extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

### VSCode `settings.json` updates

```json
{
    "dotfiles.repository": "merhard/dotfiles"
}
```

# Notes

- These settings are just a starting point. They are intended to be modified to fit the specific project requirements.

- These settings are optimized for MY development experience. They have been designed to work hand-in-hand with [my personal dotfiles](https://github.com/merhard/dotfiles). Feel free to make adjustments to fit your own preferred development experience.
