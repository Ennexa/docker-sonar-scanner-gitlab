#!/bin/sh

# Based on https://raw.githubusercontent.com/ciricihq/gitlab-sonar-scanner/master/sonar-scanner-run.sh

COMMAND="sonar-scanner"

ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

if ! grep -q sonar.projectKey "sonar-project.properties"; then
  if [ -z ${SONAR_PROJECT_KEY+x} ]; then
    SONAR_PROJECT_KEY=$CI_PROJECT_NAME
  fi
  COMMAND="$COMMAND -Dsonar.projectKey=$SONAR_PROJECT_KEY"
fi

if [ -z ${SONAR_PROJECT_VERSION+x} ]; then
  SONAR_PROJECT_VERSION=$CI_BUILD_ID
fi

if [ -z ${SONAR_GITLAB_PROJECT_ID+x} ]; then
  SONAR_GITLAB_PROJECT_ID=$CI_PROJECT_ID
fi

if [ ! -z ${SONAR_URL+x} ]; then
  COMMAND="$COMMAND -Dsonar.login=$SONAR_URL"
fi

if [ ! -z ${SONAR_TOKEN+x} ]; then
  COMMAND="$COMMAND -Dsonar.login=$SONAR_TOKEN"
fi

if [ ! -z ${SONAR_PROJECT_VERSION+x} ]; then
  COMMAND="$COMMAND -Dsonar.projectVersion=$SONAR_PROJECT_VERSION"
fi

if [ ! -z ${SONAR_DEBUG+x} ]; then
  COMMAND="$COMMAND -X"
fi

if [ ! -z ${SONAR_SOURCES+x} ]; then
  COMMAND="$COMMAND -Dsonar.sources=$SONAR_SOURCES"
fi

if [ ! -z ${SONAR_PROFILE+x} ]; then
  COMMAND="$COMMAND -Dsonar.profile=$SONAR_PROFILE"
fi

if [ ! -z ${SONAR_LANGUAGE+x} ]; then
  COMMAND="$COMMAND -Dsonar.language=$SONAR_LANGUAGE"
fi

if [ ! -z ${SONAR_ENCODING+x} ]; then
  COMMAND="$COMMAND -Dsonar.sourceEncoding=$SONAR_ENCODING"
fi

if [ ! -z ${SONAR_BRANCH+x} ]; then
  COMMAND="$COMMAND -Dsonar.branch.name=$SONAR_BRANCH"
fi

unset CI_BUILD_REF

$COMMAND $@
