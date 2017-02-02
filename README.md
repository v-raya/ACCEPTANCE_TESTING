# Acceptance testing

This repository contains a basic structure for blackbox testing of our integration environment using Capybara + RSpec.

Requires ruby 2.3+, to install gems:

```
bundle install
```

It requires an environment variable with the expected target server url:
```
TEST_URL = 'http://<environment>'
```

To run the entire suite of tests:
```
rake
```
