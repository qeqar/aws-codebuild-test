#!/usr/bin/env bash

DEBUG=1

function DEBUG() {
  if [ $DEBUG ]; then
    echo DEBUG: $*
  fi
}

env | sort

#set -x

TAGS=$(git tag | sort)
TAGSTODEPLOY=$(echo "${TAGS}" | grep "\-deployme$" | cut -d '-' -f 1)
TAGSDEPLOYED=$(echo "${TAGS}" | grep "\-deployed$" | cut -d '-' -f 1)
TAGSLEFTTODEPLOY=""
DEBUG To Deploy Tags: ${TAGSTODEPLOY}
DEBUG Deployed  Tags: ${TAGSDEPLOYED}
DEBUG Working List
for TAG in ${TAGSTODEPLOY}; do
  if [[ ${TAGSDEPLOYED} == *"${TAG}"* ]]; then
    DEBUG Already deployed... $TAG
  else
    TAGSLEFTTODEPLOY="${TAGSLEFTTODEPLOY} ${TAG}"
  fi
done
DEBUG Left to Deploy: ${TAGSLEFTTODEPLOY}

DEBUG Cloning now:
set -xe
git config -l

git clone https://qeqar@github.com/qeqar/aws-codebuild-test.git DEPLOYMETEMP

cd DEPLOYMETEMP
git config user.email "ito-peng@kaufhof.de"
git config user.name "AWS Code Build"
git config github.user qeqar
git config github.token ${GIT_ACCESS_TOKEN}

git config -l
git tag AWS-was-here
git push --tags

exit 0
NOW=$(date +%Y%m%d%H%M)

for TAG in ${TAGS}; do
    echo ${TAG}
    if [[ ${TAG} -le ${NOW} ]]; then
        exit 0
    fi
done

exit 1


timestamp-deployme
timestamp-deployed

sortieren
deployed ignorieren

< now deployen

sortieren
schleife
ältestes bis neustes

deployen
tag "deployed" setzen mit altem timestamp

git push --tags
