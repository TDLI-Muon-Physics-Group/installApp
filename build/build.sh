#!/bin/bash

IMAGE="test:v1"

# BUILD GEANT4
docker build --secret id=id_rsa,src=$HOME/.ssh/id_ed25519 -t siewyanhoh/geant4:10.7.3.2 -f Dockerfile_g4 .

# BUILD CRYSIM
docker build --secret id=id_rsa,src=$HOME/.ssh/id_ed25519 -t siewyanhoh/musim:crySim-1.1  -f Dockerfile_crysim .

# BUILD ROOT
docker build --platform linux/x86_64 --secret id=id_rsa,src=$HOME/.ssh/id_ed25519 -t siewyanhoh/musim:root-6.28.12 -f Dockerfile_root .
