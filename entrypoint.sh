#!/bin/sh

function main(){
    nginx
    consul-template "${@}"
}

main "${@}"