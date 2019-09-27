FROM debian:latest as getDepCharge

RUN apt-get update && apt-get install -y z80asm unzip curl wget
# Download the prerelease version of DepCharge (until v2 comes out)
# After which, we can switch back to this:
#   RUN curl -s https://api.github.com/repos/centerorbit/depcharge/releases/latest | grep "browser_download_url.*zip" | grep linux | cut -d : -f 2,3 | tr -d '"' | wget -qi -
RUN curl -s https://api.github.com/repos/centerorbit/depcharge/releases?prerelease=true | grep "browser_download_url.*zip" | grep linux | cut -d : -f 2,3 | tr -d '"'| head -1 | wget -qi -
RUN unzip *linux-x64.zip

FROM registry.gitlab.com/centerorbit/z80asm:latest
RUN apk update && apk add zip
COPY --from=getDepCharge depcharge /bin/depcharge

COPY ./docker/entrypoint.sh /bin/entrypoint
RUN chmod u+x /bin/entrypoint

ENTRYPOINT ["/bin/entrypoint"]
CMD ["build"]