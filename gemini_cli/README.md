# Gemini CLI Docker Setup

## Project Structure

```
your-project/
├── Dockerfile
├── .env.gemini          # Environment variables (API keys)
├── workspace/           # Your working directory
│   └── (your files)
└── README.md
```

## Commands

### Build the Docker Image

```powershell
docker build -t gemini-cli-image .
```

**What this does:**
- `docker build` - Builds a Docker image from the Dockerfile
- `-t gemini-cli-image` - Tags the image with the name "gemini-cli-image"
- `.` - Uses the current directory as the build context

### Run the Container

```powershell
docker run -it --rm -v "${PWD}/workspace:/workspace" --env-file .env.gemini gemini-cli-image
```

**Command breakdown:**
- `docker run` - Creates and starts a new container
- `-it` - Interactive mode with terminal access (allows you to use the CLI)
- `--rm` - Automatically removes the container when it stops (cleanup)
- `-v "${PWD}/workspace:/workspace"` - Mounts your local `workspace` folder to `/workspace` inside the container
- `--env-file .env.gemini` - Loads environment variables from the `.env.gemini` file
- `gemini-cli-image` - The name of the Docker image to run

## Required Files

### `.env.gemini`
Contains your API configuration:
```
GEMINI_API_KEY=your_api_key_here
```

### `workspace/` folder
Your working directory that gets mounted into the container. Place your input files here and outputs will be saved here.