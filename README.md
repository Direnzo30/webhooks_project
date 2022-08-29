# Webhooks

## Dependencies

- ruby-2.7.6
- postgres-11+

## Gems added

- annotate: Documenting the Models in order to have them up to date with the database attributes
- dotenv-rails: Add the ability to use .env files within the project
- rack-cors: For handling the cross origin requests
- yard: For generating the app documentation
- yard-activesupport-concern: Plugin for adding documentation to the concerns

# Generating DOC

1. bundle exec yard config load_plugins true
2. bundle exec yardoc --private (for including the private methods)
