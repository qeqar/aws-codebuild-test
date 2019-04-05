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
  TAGWITHSECONDS="${TAG}00"
  TAGREADABLE=$(date -d "${TAGWITHSECONDS:0:8} ${TAGWITHSECONDS:8:2}:${TAGWITHSECONDS:10:2}:${TAGWITHSECONDS:12:2}")
  DEBUG "Processing Tag ${TAG} which is set to deploy at ${TAGREADABLE}"
  NOW=$(date +%Y%m%d%H%M)
  if [[ ${TAG} -ge ${NOW} ]]; then
    DEBUG $TAG is in the future, aborting Deployment process
    exit 0
  fi

  DEBUG Cloning Tag ${TAG}-deployme now:
  rm -rf DEPLOYMETMP
  set -e
  git clone https://${GITHUB_USER}:${GITHUB_ACCESS_TOKEN}@github.com/qeqar/aws-codebuild-test.git DEPLOYMETMP

  cd DEPLOYMETMP
  git checkout ${TAG}-deployme
  git log -1
  DEBUG Deploying to S3
  aws s3 sync --delete content/ s3://www.feelx.de/
  DEBUG Invalidating Cloudfront
  aws cloudfront create-invalidation --distribution-id E1646E9SZ98W2F --path '/*'
  git config user.email "${GIT_AUTHOR_NAME}"
  git config user.name "${GIT_AUTHO_EMAIL}"

  git tag ${TAG}-deployed
  git push --tags
  cd ..
done
exit 0
