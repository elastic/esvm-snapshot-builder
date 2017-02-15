# esvm-snapshot-builder

A collection of docker containers for building the esvm snapshots.

## setup

1. Create a `.env` file at the root of the repository with values for `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `S3_BUCKET`, and `S3_PREFIX`
3. execute `./run.sh` in a terminal and watch the build go
  
Keep in mind:
- the command will continue to run in the background if you `ctrl-c` as the logs are streaming
- `docker-compose down` will stop the containers, and they will naturally stop after they build once
- `docker-compose logs -f` will start streaming the logs again
- The list of branches to build are in `generate-config.js`