#!/usr/bin/env bash

DEBUG=1

function DEBUG() {
  if [ $DEBUG ]; then
    echo DEBUG: $*
  fi
}

source .secretenv 2> /dev/null

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

for TAG in ${TAGSLEFTTODEPLOY}; do
  DEBUG Cloning Tag ${TAG}-deployme now:
  rm -rf DEPLOYMETMP
  set -e
  git clone https://${GITHUB_USER}:${GITHUB_ACCESS_TOKEN}@github.com/qeqar/aws-codebuild-test.git DEPLOYMETMP

  cd DEPLOYMETMP
  git checkout ${TAG}-deployme
  git log -1
  aws s3 sync --delete content/ s3://www.feelx.de/
  aws cloudfront create-invalidation --distribution-id E1646E9SZ98W2F --path '/*'
  git config user.email "${GIT_AUTHOR_NAME}"
  git config user.name "${GIT_AUTHO_EMAIL}"

  git tag ${TAG}-deployed
  git push --tags
  cd ..
  exit 0
done
exit 0
