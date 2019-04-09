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
circleci local execute --job build
```