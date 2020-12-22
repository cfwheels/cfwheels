FROM ortussolutions/commandbox

LABEL maintainer "CFWheels Core Team"

#Hard Code our engine environment
ENV CFENGINE adobe@2021.0.0

ENV APP_DIR   "/cfwheels-test-suite"
ENV HEALTHCHECK_URI "http://127.0.0.1:8080/"

COPY . /cfwheels-test-suite

# WARM UP THE SERVER
RUN ${BUILD_DIR}/util/warmup-server.sh
