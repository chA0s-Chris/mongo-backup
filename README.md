# mongo-backup

An ultra-small Docker image containing MongoDB's `mongodump` tool. It enables seamless creation of MongoDB backups without the need to install MongoDB or its dependencies on your system.

[![GitHub License](https://img.shields.io/github/license/chA0s-Chris/mongo-backup?style=for-the-badge)](https://github.com/chA0s-Chris/mongo-backup/blob/main/LICENSE)
[![Docker Image Version (tag)](https://img.shields.io/docker/v/chaos/mongo-backup/latest?style=for-the-badge)](https://hub.docker.com/r/chaos/mongo-backup)
[![Docker Image Size](https://img.shields.io/docker/image-size/chaos/mongo-backup?style=for-the-badge)](https://hub.docker.com/r/chaos/mongo-backup)
[![Docker Pulls](https://img.shields.io/docker/pulls/chaos/mongo-backup?style=for-the-badge)](https://hub.docker.com/r/chaos/mongo-backup)
[![GitHub last commit](https://img.shields.io/github/last-commit/chA0s-Chris/mongo-backup?style=for-the-badge)](https://github.com/chA0s-Chris/mongo-backup/commits/)
[![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/chA0s-Chris/mongo-backup/ci.yml?style=for-the-badge)]()

## Table of Contents

- [Features](#features)
- [Getting Started](#getting-started)
    - [Prerequisites](#prerequisites)
    - [Usage](#usage)
- [Security Considerations](#security-considerations)
- [Contributing](#contributing)
- [License](#license)

## Features

- **Ultra-small**: The image is about 20 MB in size and contains only `mongodump` and its dependencies.
- **No installation required**: You can use `mongodump` without installing MongoDB or its dependencies on your system.
- **Easy to use**: The image can be used as a drop-in replacement for `mongodump` in your backup scripts.

## Getting Started

### Prerequisites

- Docker installed on your machine. That's it.

### Usage

To create a backup of your MongoDB database, run the following command:

```bash
docker run --rm -v /my/backup/folder:/backup chaos/mongo-backup:latest \
    --uri mongodb://localhost:27017 \
    --db MyDatabase \
    --gzip \
    --archive=/backup/mybackup.gz
```

**Explanation:**

* `--rm`: Automatically remove the container when it exits.
* `-v /my/backup/folder:/backup`: Mounts the local folder `/my/backup/folder/` to the container's `/backup` directory.
* `chaos/mongo-backup:latest`: Use the latest version of the `chaos/mongo-backup` image.
* `--uri mongodb://localhost:27017`: The MongoDB connection string. You can also use `mongodb://username:password@localhost:27017`.
* `--db MyDatabase`: The name of the database you want to dump.
* `--gzip`: Compress the output using gzip.
* `--archive=/backup/mybackup.gz`: Store the backup in a single file named `mybackup.gz` in the container's `/backup` directory. 

You can also specify the `--out` option instead of `--archive` to create a directory containing all collections as separate dumps.

See the [official MongoDB documentation](https://www.mongodb.com/docs/database-tools/mongodump/) for more options.

## Security Considerations 

When using this image on the command line or in your backup scripts, especially in multi-user environments, be cautious about exposing sensitive information such as the passwords.

The recommended approach is to provide a YAML configuration for `mongodump` containing the connection string:

```yaml
uri: mongodb://username:password@localhost:27017
```

Then, run the following command:

```bash
docker run --rm -v /my/backup/folder:/backup \
    -v /path/to/config.yaml:/config.yaml \
    chaos/mongo-backup:latest \
    --db MyDatabase \
    --gzip \
    --archive=/backup/mybackup.gz
```

## License

MIT License - see [LICENSE](./LICENSE) for more information.
