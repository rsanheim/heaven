set -ex

USERNAME=rsanheim
IMAGE=heaven

docker build -t $USERNAME/$IMAGE:latest .
