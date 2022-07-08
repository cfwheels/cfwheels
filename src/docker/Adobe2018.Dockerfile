FROM ortussolutions/commandbox:latest

LABEL maintainer "CFWheels Core Team"

#Hard Code our engine environment
#ENV BOX_SERVER_APP_CFENGINE adobe@2018.0.9+318650

ENV APP_DIR                 "/cfwheels-test-suite"
ENV HEALTHCHECK_URI         "http://127.0.0.1:8080/"
ENV ENV_MODE                "remote"
ENV BOX_SERVER_CFCONFIGFILE "/src/docker/Adobe2018.CFConfig.json"
ENV BOX_SERVER_PROFILE      "none"

COPY . /cfwheels-test-suite
COPY ./src/docker/Adobe2018.server.json /cfwheels-test-suite/server.json

# WARM UP THE SERVER
RUN ${BUILD_DIR}/util/warmup-server.sh
