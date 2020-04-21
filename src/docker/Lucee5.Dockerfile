FROM ortussolutions/commandbox:lucee5

LABEL maintainer "CFWheels Core Team"

ENV APP_DIR   "/cfwheels-test-suite"
ENV ENV_MODE "production"
ENV HEALTHCHECK_URI "http://127.0.0.1:8443/health.cfm"
ENV HEADLESS "true"
ENV CFENGINE "lucee@5"

COPY . /cfwheels-test-suite

# WARM UP THE SERVER
RUN ${BUILD_DIR}/util/warmup-server.sh
