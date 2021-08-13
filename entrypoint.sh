#!/bin/bash

cd /flora-blockchain

. ./activate

if [[ $(flora keys show | wc -l) -lt 5 ]]; then
    if [[ ${keys} == "generate" ]]; then
      echo "to use your own keys pass them as a text file -v /path/to/keyfile:/path/in/container and -e keys=\"/path/in/container\""
      flora init && flora keys generate
    elif [[ ${keys} == "copy" ]]; then
      if [[ -z ${ca} ]]; then
        echo "A path to a copy of the farmer peer's ssl/ca required."
        exit
      else
      flora init -c ${ca}
      fi
    elif [[ ${keys} == "type" ]]; then
      flora init
      echo "Call from docker shell: flora keys add"
      echo "Restart the container after mnemonic input"
    else
      flora init && flora keys add -f ${keys}
    fi
    
    sed -i 's/localhost/127.0.0.1/g' ~/.flora/mainnet/config/config.yaml
else
    for p in ${plots_dir//:/ }; do
        mkdir -p ${p}
        if [[ ! "$(ls -A $p)" ]]; then
            echo "Plots directory '${p}' appears to be empty, try mounting a plot directory with the docker -v command"
        fi
        flora plots add -d ${p}
    done

    if [[ ${farmer} == 'true' ]]; then
      flora start farmer-only
    elif [[ ${harvester} == 'true' ]]; then
      if [[ -z ${farmer_address} || -z ${farmer_port} || -z ${ca} ]]; then
        echo "A farmer peer address, port, and ca path are required."
        exit
      else
        flora configure --set-farmer-peer ${farmer_address}:${farmer_port}
        flora start harvester
      fi
    else
      flora start farmer
    fi
fi

finish () {
    echo "$(date): Shutting down flora"
    flora stop all
    exit 0
}

trap finish SIGTERM SIGINT SIGQUIT

sleep infinity &
wait $!
