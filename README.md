# ZendeskSearch

## Requirements

1. Ruby 2+
2. bundler

## Setup

```bash
  bundle install --path vendor/bundle
```

running the test

```bash
  bundle exec rspec
```

## Usage

To run the application

```bash
    exe/zendesk-search    
```

You can place more .json source files in the `data` directory and update source_association_config.yml.
The changes will be picked up once you start the application again.
Please note though that making these changes will break some tests.