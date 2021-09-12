# PHPUnit Docker Image

A containerized version of the PHPUnit framework to run your Unit tests without any additional dependencies

# Usage

```docker
# Print the version
docker run --rm safesecurity/phpunit:latest --version

# Mount a directory and run tests
docker run --rm -v "$PWD/tests:/app" safesecurity/phpunit:latest
```