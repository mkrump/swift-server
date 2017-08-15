# swift-server

This repository contains a Swift HTTP server

### Requirements
[Swift 3.1+](https://swift.org/download/#releases)

### Running
```
swift build
.build/debug/Main -p <port> -d <directory>
```

### Tests
#### Unit tests 
```
swift build
swift test
```

#### Acceptance tests

Running the shell script `acceptance_tests.sh`, will download `cob_spec` and
run the acceptance test suite. If you wish to use the web ui for `cob_spec` run
`acceptance_tests_webui.sh` instead.

### Heroku 
The server has been deployed to Heroku with the various virtual routes required
by `cob_spec`.  
[https://swift-http-server.herokuapp.com/](https://swift-http-server.herokuapp.com/)
