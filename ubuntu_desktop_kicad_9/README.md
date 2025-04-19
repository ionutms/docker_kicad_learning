```bash
docker run -d -p 5901:5901 --name ubuntu-desktop ubuntu-desktop
```

```bash
docker exec ubuntu-desktop kicad-cli --help
```

```bash
docker exec ubuntu-desktop bash -c "cd /root/Downloads && git clone https://github.com/ionutms/Minimal_MAX32650.git"
```

```bash
docker exec ubuntu-desktop bash -c "cd /root/Downloads && git clone https://github.com/AlexanderBrevig/kicad-gruvbox-theme.git"
```

```bash
docker exec ubuntu-desktop bash -c "cp /root/Downloads/kicad-gruvbox-theme/colors/Gruvbox.json /root/.local/share/kicad/9.0/3rdparty/colors/"
```

```bash
docker exec ubuntu-desktop bash -c "cd /root/Downloads/Minimal_MAX32650/minimal_max32650 && kicad-cli sch export pdf minimal_max32650.kicad_sch -t gruvbox"
```
