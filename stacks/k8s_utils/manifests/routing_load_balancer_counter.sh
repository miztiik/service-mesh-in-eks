#!/bin/bash
GATEWAY_URL=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
tot_req=0
c1_h=0
c2_h=0


# SET individual pod hostname
p_hosts=$(kubectl get pods -n miztiik-automation-ns -o=jsonpath='{range .items[*]}{"\n"}{.metadata.name}{range .spec.containers[*]}{end}{end}' | grep v2 | sed 's/\\n/ /g')
c1_h_name=$(echo $p_hosts | cut -d" " -f1)
c2_h_name=$(echo $p_hosts | cut -d" " -f2)


echo '\ncontainer 1 hostname : '$c1_h_name
echo 'container 2 hostname : '$c2_h_name


for i in {1..100}
do
    resp=$(curl --silent ${GATEWAY_URL})
    c_h=$( echo $resp  | cut -d: -f1 )
    v=$( echo $resp  | cut -d: -f2 )
    # We are doing round robin only for v2
    if [[ "$v" == 'v2' ]]; then
        let "tot_req++"
        if [[ "$c_h" == $c1_h_name ]]; then
            let "c1_h++"
        elif [[ "$c_h" == $c2_h_name ]]; then
            let "c2_h++"
        fi
    fi
done

echo '\n               Total requests to v2: '$tot_req
echo '\nCount of requests to v2 container 1: '$c1_h
echo 'Count of requests to v2 container 2: '$c2_h
echo '\n'

