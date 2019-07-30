FROM openjdk:8-jre-alpine

ARG SONAR_SCANNER_VERSION="4.0.0.1744"

RUN apk add --no-cache curl grep sed unzip nodejs nodejs-npm

ENV TZ=Asia/Kolkata

ENV SONAR_URL="https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux.zip"
ENV SONAR_RUNNER_HOME="/opt/sonar-scanner"
ENV PATH $PATH:$SONAR_RUNNER_HOME/bin

RUN mkdir -p /opt
WORKDIR /opt

RUN curl -Lo ./sonar-scanner.zip $SONAR_URL && \
	unzip sonar-scanner.zip && \
	mv sonar-scanner-${SONAR_SCANNER_VERSION}-linux /opt/sonar-scanner && \
	rm sonar-scanner.zip

# Do not use embedded jre
RUN sed -i 's/use_embedded_jre=true/use_embedded_jre=false/g' $SONAR_RUNNER_HOME/bin/sonar-scanner

ENTRYPOINT ["docker-entrypoint.sh"]
