docker build --build-arg UID=$(id -u Debian-taskd) --build-arg GID=$(id -g Debian-taskd) -f Dockerfile . -t taskd
