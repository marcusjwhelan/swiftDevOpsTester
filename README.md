<p align="center">
    <img src="https://user-images.githubusercontent.com/1342803/36623515-7293b4ec-18d3-11e8-85ab-4e2f8fb38fbd.png" width="320" alt="API Template">
    <br>
    <br>
    <a href="http://docs.vapor.codes/3.0/">
        <img src="http://img.shields.io/badge/read_the-docs-2196f3.svg" alt="Documentation">
    </a>
    <a href="https://discord.gg/vapor">
        <img src="https://img.shields.io/discord/431917998102675485.svg" alt="Team Chat">
    </a>
    <a href="LICENSE">
        <img src="http://img.shields.io/badge/license-MIT-brightgreen.svg" alt="MIT License">
    </a>
    <a href="https://circleci.com/gh/vapor/api-template">
        <img src="https://circleci.com/gh/vapor/api-template.svg?style=shield" alt="Continuous Integration">
    </a>
    <a href="https://swift.org">
        <img src="http://img.shields.io/badge/swift-4.1-brightgreen.svg" alt="Swift 4.1">
    </a>
</p>

# Start Development
Cloning
```bash
git clone --recursive https://github.com/marcusjwhelan/swiftDevOpsTester.git
```

Start container cluster in detached mode
don't cache the build setup
```bash
docker-compose build --no-cache
docker-compose up -d
```

Attach to container 
> hit enter twice to get to bash prompt of container
```bash
docker attach vapor_it_container
```

In api:dev container build application and start it
```bash
swift build && swift run Run serve -b 0.0.0.0
```
Should get output
> Server starting on http://0.0.0.0:8080

Application can be accessed now at localhost:8080/users for list of users or posting.

# Test locally

Runs local build structured test from /.circleci/config.yml
```bash
circleci local execute --job build-image
```

# Pushing to Docker hub
All that needs to be done is commit to the master branch.

Possibly changed to it having to be a pull request. not sure if it has to be on master

## Add content through users
Using postman hit address `localhost:8080/users/` with a post request holding `{"username":"content","password":"admin"}`. Now your first user is added. This is the simple route on the end of an api. 

# Turn off dev env
```bash
docker-compose down
```

# Setting up project
When adding client I used gatsby from the outside then `cd` into gatsby client directory. Did all the git init work and created new repo on github. Once that was done I navigated back to project directory and made the client directory a submodule with 
```bash
git submodule add https://github.com/marcusjwhelan/swiftDevOpsTesterReact.git client
```
And a `git push -f`
