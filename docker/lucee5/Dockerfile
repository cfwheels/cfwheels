FROM ortussolutions/commandbox:latest
RUN echo "------------------------------- Starting Dockerfile -------------------------------"

run ls /wheels-test-suite

LABEL maintainer "Wheels Core Team"

#Add the H2 extension
ADD https://ext.lucee.org/org.h2-1.3.172.lex /usr/local/lib/serverHome/WEB-INF/lucee-server/deploy/org.h2-1.3.172.lex

ENV APP_DIR                 "/wheels-test-suite"
ENV HEALTHCHECK_URI         "http://127.0.0.1:8080/"
ENV ENV_MODE                "remote"
ENV BOX_SERVER_CFCONFIGFILE "/wheels-test-suite/docker/lucee5/CFConfig.json"
ENV BOX_SERVER_PROFILE      "none"

# WARM UP THE SERVER
RUN ${BUILD_DIR}/util/warmup-server.sh

RUN echo "------------------------------- Ending Dockerfile -------------------------------"
