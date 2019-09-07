FROM debian:latest

# Install assembler
RUN apt-get update && apt-get install -y z80asm

# Setup build directories
RUN mkdir /code

# Copy in SDK
WORKDIR /code
COPY . /code

# Build 'Hello World' to ensure we're setup properly.
RUN z80asm --includepath="targets/WP-2450 DS" -i ./samples/hello-world/hello.asm -o "./builds/WP-2410 DS/HELLO.APL"


COPY ./docker/entrypoint.sh /entrypoint.sh
RUN chmod u+x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["build"]