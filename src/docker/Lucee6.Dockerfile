ARG ENGINE_VERSION=Lucee@6
ARG JDK_TAG=jdk11
ARG IMAGE_VERSION=3.6.3

FROM ortussolutions/commandbox:${JDK_TAG}-${IMAGE_VERSION}

LABEL maintainer "CFWheels Core Team"

#Add the H2 extension
ADD https://ext.lucee.org/org.h2-1.3.172.lex /usr/local/lib/serverHome/WEB-INF/lucee-server/deploy/org.h2-1.3.172.lex

ENV APP_DIR                 "/cfwheels-test-suite"
ENV HEALTHCHECK_URI         "http://127.0.0.1:8080/"
ENV ENV_MODE                "remote"
ENV BOX_SERVER_CFCONFIGFILE "/cfwheels-test-suite/src/docker/Lucee6.CFConfig.json"
ENV BOX_SERVER_PROFILE      "none"

COPY . /cfwheels-test-suite
COPY ./src/docker/Lucee6.server.json /cfwheels-test-suite/server.json

# WARM UP THE SERVER
RUN ${BUILD_DIR}/util/warmup-server.sh
