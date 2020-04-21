FROM ortussolutions/commandbox:adobe2016

LABEL maintainer "CFWheels Core Team"

ENV APP_DIR   "/cfwheels-test-suite"
ENV HEALTHCHECK_URI "http://127.0.0.1:8080/"

COPY . /cfwheels-test-suite

# WARM UP THE SERVER
RUN ${BUILD_DIR}/util/warmup-server.sh
