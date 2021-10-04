# Psalm plugin Yii2

## Installation

The preferred method is with composer.

```bash
composer --dev require practically/psalm-plugin-yii2 1.x-dev
psalm-plugin enable practically/psalm-plugin-yii2
```

## Contributing

### Getting set up

Clone the repo and run `composer install`.
Then start hacking!

### Testing

All new features of bug fixes must be tested. Testing is with phpunit and can
be run with the following command:

```bash
composer run-script test
```

### Coding Standards

This library uses [Practically](https://practically.io/) coding standards and `squizlabs/php_codesniffer`
for linting. There is a composer script for this:

```bash
composer run-script cs:check
```

### Pull Requests

Before you create a pull request with you changes, the pre-commit script must
pass. That can be run as follows:

```bash
composer run-script pre-commit
```

## Credits

This package is created and maintained by [Practically.io](https://practically.io/)
