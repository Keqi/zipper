# Zipper

The Zipper application is a JSON RESTful API allowing users to upload files to the local storage. Files are packed into a .zip file and encrypted with a strong random password. A user can authenticate themselves through JWT tokens and retrieve list of the uploaded files.

## Installation

- Run `bundle install`
- Copy the `.env.example` file into the `.env` file and add your database credentials.
- Ask the owner of the repository to send you the `development.key` and `test.key` to decrypt credentials files.

## Running tests

- Type `rspec` or `bundle exec rspec`

## Documentation

- The documentation follows the [OpenAPI](https://swagger.io/specification/) convention and is generated using rswag gem. You access it at `/api/docs` endpoint or by reading the `/swagger/v1/swagger.yaml` file.
