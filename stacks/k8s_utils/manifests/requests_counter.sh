#!/bin/bash
GATEWAY_URL=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
v1=0
v2=0
v3=0
v4=0
for i in {1..100}
do
    v=$(curl --silent ${GATEWAY_URL} | cut -d: -f2)
    if [[ "$v" == 'v1' ]]; then
        let "v1++"
    elif [[ "$v" == 'v2' ]]; then
       let "v2++"
    elif [[ "$v" == 'v3' ]]; then
        let "v3++"
    elif [[ "$v" == 'v4' ]]; then
        let "v4++"
    fi
done

# BASH random generator between 1 and 4
# $(( ( RANDOM % 4 ) + 1 ))

echo 'Count of v1 requests: '$v1
echo 'Count of v2 requests: '$v2
echo 'Count of v3 requests: '$v3
echo 'Count of v4 requests: '$v4
