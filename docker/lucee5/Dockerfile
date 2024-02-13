FROM ortussolutions/commandbox:latest

LABEL maintainer "CFWheels Core Team"

RUN echo "PWD" && pwd
RUN ls

#Add the H2 extension
ADD https://ext.lucee.org/org.h2-1.3.172.lex /usr/local/lib/serverHome/WEB-INF/lucee-server/deploy/org.h2-1.3.172.lex

ENV APP_DIR                 "/app"
ENV HEALTHCHECK_URI         "http://127.0.0.1:8080/"
ENV ENV_MODE                "remote"
ENV BOX_SERVER_CFCONFIGFILE "/app/docker/lucee5/CFConfig.json"
ENV BOX_SERVER_PROFILE      "none"
ENV BOX_INSTALL				      "true"

# WARM UP THE SERVER
RUN ${BUILD_DIR}/util/warmup-server.sh
