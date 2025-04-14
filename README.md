# docker_kicad_learning

## Pull one of the Kicad official images
```bash
docker pull kicad/kicad:9.0
```

## Tag the Image
```bash
docker tag kicad/kicad:9.0 ionutms/kicad:9.0
```

## Push to Docker Hub with Your Username
```bash
docker login
# Enter your Docker Hub credentials when prompted
docker push ionutms/kicad:9.0
```

## Run the image
```bash
# -it creates an interactive terminal session inside the container
# --rm to automatically remove the container when it exits
docker run -it --rm ionutms/kicad:9.0
```