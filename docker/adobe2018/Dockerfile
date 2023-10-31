FROM ortussolutions/commandbox:latest

LABEL maintainer "CFWheels Core Team"

ENV APP_DIR                 "/cfwheels-test-suite"
ENV HEALTHCHECK_URI         "http://127.0.0.1:8080/"
ENV ENV_MODE                "remote"
ENV BOX_SERVER_CFCONFIGFILE "/cfwheels-test-suite/docker/adobe2018/CFConfig.json"
ENV BOX_SERVER_PROFILE      "none"

# WARM UP THE SERVER
RUN ${BUILD_DIR}/util/warmup-server.sh
