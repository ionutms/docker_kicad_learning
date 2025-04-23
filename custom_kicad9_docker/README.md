# docker_kicad_learning

## Build the image from a dockerfile
```bash
docker build -t ionutms/kicad:V1.0 -f custom_kicad_9.dockerfile .
```

## Pull one of the Kicad official images
```bash
docker pull kicad/kicad:9.0
```

## Tag the Image
```bash
docker tag kicad/kicad:9.0 ionutms/kicad:V1.0
```

## Push to Docker Hub with Your Username
```bash
docker login
# Enter your Docker Hub credentials when prompted
docker push ionutms/kicad:V1.0
```

## Run the image
```bash
# -it creates an interactive terminal session inside the container
# --rm to automatically remove the container when it exits
docker run -it --rm ionutms/kicad:V1.0
```

## Inspect the image
```bash
docker inspect ionutms/kicad:V1.0
```

## View container logs
```bash
docker logs ionutms/kicad:V1.0
```

## Extract files from container
```bash
# docker cp container_name:/path/in/container /path/on/host
docker cp ionutms/kicad:V1.0:/root/.config/kicad/9.0/kicad_common.json ./kicad_common.json
```