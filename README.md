# NVIDIA Orin ultralytics

Sample workspace to quickly deploy yolo models on NVIDIA ORIN.

## Dependencies

- Docker
- Docker compose: `apt install docker-compose`
- Task `snap install task --classic`
- Jetpack 
    - Gstreamer
    - Deepstream-6.2

## Usage

- test: `docker compose run ultralytics 'yolo'`
- else: `task run <taskname>`


https://github.com/ultralytics/ultralytics/issues/2025