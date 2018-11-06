set -ex

USERNAME=firstleads
IMAGE=heaven

docker build -t $USERNAME/$IMAGE:latest .
