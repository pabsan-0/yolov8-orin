# Ultralytics YOLO 🚀, AGPL-3.0 license
# Builds ultralytics/ultralytics:jetson image on DockerHub https://hub.docker.com/r/ultralytics/ultralytics
# Supports JetPack for YOLOv8 on Jetson Nano, TX1/TX2, Xavier NX, AGX Xavier, AGX Orin, and Orin NX

# Start FROM https://catalog.ngc.nvidia.com/orgs/nvidia/containers/l4t-pytorch
FROM nvcr.io/nvidia/l4t-pytorch:r35.2.1-pth2.0-py3

# Downloads to user config dir
ADD https://ultralytics.com/assets/Arial.ttf https://ultralytics.com/assets/Arial.Unicode.ttf /root/.config/Ultralytics/

# Install linux packages
# g++ required to build 'tflite_support' package
RUN apt update \
    && apt install --no-install-recommends -y gcc git zip curl htop libgl1-mesa-glx libglib2.0-0 libpython3-dev gnupg g++
# RUN alias python=python3

# Create working directory
RUN mkdir -p /usr/src/ultralytics
WORKDIR /usr/src/ultralytics

# Copy contents
# COPY . /usr/src/app  (issues as not a .git directory)
RUN git clone https://github.com/ultralytics/ultralytics /usr/src/ultralytics
ADD https://github.com/ultralytics/assets/releases/download/v0.0.0/yolov8n.pt /usr/src/ultralytics/
RUN sed -i '/opencv/d' requirements.txt

# Install pip packages
RUN python3 -m pip install --upgrade pip wheel
RUN pip install --no-cache -e .

# Optionals for tensorrt export
RUN wget https://nvidia.box.com/shared/static/v59xkrnvederwewo2f1jtv6yurl92xso.whl -O onnxruntime_gpu.whl \
    && pip3 install onnxruntime_gpu.whl \
    && pip3 install --no-cache onnx>=1.12.0 onnxsim>=0.4.17

# Set environment variables
ENV OMP_NUM_THREADS=1


# Usage Examples -------------------------------------------------------------------------------------------------------

# Build and Push
# t=ultralytics/ultralytics:latest-jetson && sudo docker build --platform linux/arm64 -f docker/Dockerfile-jetson -t $t . && sudo docker push $t

# Pull and Run
# t=ultralytics/ultralytics:jetson && sudo docker pull $t && sudo docker run -it --ipc=host --gpus all $t
