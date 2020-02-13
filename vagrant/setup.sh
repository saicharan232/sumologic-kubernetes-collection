#!/bin/bash

source envs.sh
microk8s.enable registry
sudo apt-get install -y ruby libsnappy-dev
sudo gem install bundler
cd /vagrant
./ci/build.sh
docker tag sumologic/kubernetes-fluentd:local localhost:32000/sumologic/kubernetes-fluentd
docker push localhost:32000/sumologic/kubernetes-fluentd

cd deploy/helm/sumologic
helm dependency update
helm del --purge collection
helm install . \
    --name collection \
    --namespace sumologic \
    --set sumologic.accessId=${ACCESS_ID} \
    --set sumologic.accessKey=${ACCESS_KEY} \
    --set prometheus-operator.prometheus.prometheusSpec.externalLabels.cluster="cluster" \
    --set sumologic.clusterName="cluster" \
    --no-crd-hook \
    --set sumologic.endpoint=${ENDPOINT} \
    --set sumologic.traces.enable=true \
    --set image.repository=localhost:32000/sumologic/kubernetes-fluentd \
    --set image.tag=latest \
    --set image.pullPolicy=Always \
    --debug \
    --dry-run | less