# syntax=docker/dockerfile:1.4

FROM --platform=$BUILDPLATFORM python:3.9-alpine AS builder
EXPOSE 8000
WORKDIR /app 
COPY requirement.txt /app
RUN pip3 install -r requirement.txt --no-cache-dir
COPY . /app 
ENTRYPOINT ["python3"] 
CMD ["manage.py", "runserver", "0:8087"]

FROM builder as dev-envs
RUN <<EOF
apk update
apk add git
EOF

RUN <<EOF
addgroup -S docker
adduser -S --shell /bin/bash --ingroup docker vscode
EOF
# install Docker tools (cli, buildx, compose)
COPY --from=gloursdocker/docker / /
CMD ["manage.py", "runserver", "0:8087"]