FROM ortussolutions/commandbox:commandbox-5.2.0

LABEL maintainer "CFWheels Core Team"

#Hard Code our engine environment
ENV CFENGINE lucee@5.3.5+92

#Add the H2 extension
ADD https://ext.lucee.org/org.h2-1.3.172.lex $SERVER_HOME_DIRECTORY/WEB-INF/lucee-server/deploy/org.h2-1.3.172.lex

ENV APP_DIR   "/cfwheels-test-suite"
ENV HEALTHCHECK_URI "http://127.0.0.1:8080/"

COPY . /cfwheels-test-suite

# WARM UP THE SERVER
RUN ${BUILD_DIR}/util/warmup-server.sh
