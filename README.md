# Docker GHA Training

The goal of this training is to learn how to use Docker and GitHub Actions to build, test and deploy a simple web application. In this training, we will use a simple web application written in Python and Flask.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Docker Image Creation

1. Fork the repo : done but on GitHub a fork can't be private
2. I used the alpine tag to get the latest alpine version of python. Alpine is a small, secure base image.
3. I build the image with the command `docker build -t myapp:1 .`
4. I run the container with the command `docker run --name myapp_container -p 8080:5000 myapp:1`
5. I check if the container is running and accessible with the command `docker ps` to list all the running containers.
![img.png](docker_ps.png)

## Docker Compose Configuration

1. I added `restart: unless-stopped` to `myapp` service, this way it always restarts unless it's manually stopped
2. I chose the latest alpine version (as of 21/07/2025). I then created a `secrets` folder with a `db_password.txt`
file that contains the password. I defined a volume and added a condition to start the myapp container only after the 
postgres service is marked as healthy using the `depends_on` option with `condition: service_healthy`. This condition requires
that I define a healthcheck on the postgres service, therefor I added a `healthcheck` to run a postgres specific command for to get the status of a database.
Finally, I started the stack with the command `docker compose up`.

## CI/CD with GitHub Actions

### Build and Push Image to GitHub Container Registry
I used the `docker/login-action` action to log in to the GitHub Container Registry, then I use the `docker/build-push-action`
to build and push the image to the registry. It also creates a package with the image in the repository. 
Finally, I use `actions/attest-build-provenance` to have the url of the new image in the action summary.

### Build and test project

I set up a python environment with python version of 3.x with `actions/setup-python`, then install the app dependencies.
I run the main.py file in the background with `&` and wait  5 seconds to make sure the server has started before testing and endpoint.
Finally, I test the /books endpoint with curl and --fail option.

## Testing and Submission

The first 2 parts were quite easy because I have written many docker and compose files. 
However, I had to look up how to check the [postgres database status](https://stackoverflow.com/questions/46193659/query-to-check-postgresql-database-status), 
as well as [how to use docker secrets](https://docs.docker.com/compose/how-tos/use-secrets/) because I had forgotten.

The GitHub workflows were a bit harder. I had to commit and push many times before getting it right.
In the end I used what I had done during the last course to push an image to the GiHub Container Registry.

As for the build and test action, I initially tried building and testing the app using Docker, but ran into a few issues:
- the `secrets` folder isn't on the repository, I needed to re-create it during the job
- the `docker compose up` command runs in attached mode so the next step was never reached, and running it in detached mode
would cause the next step to run before the services are ready.

It was becoming too complex, so I decided to build the project without docker and wait 5 seconds before testing an endpoint.


To make this production ready the next step would be to use a production server instead of the default development server of Flask.
As well as using Nginx to better configure the server.