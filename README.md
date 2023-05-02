# NVIDIA Orin ultralytics

Sample workspace to quickly deploy yolo models on NVIDIA ORIN.

## Dependencies

- Docker
- Jetpack 5.1.1
- Docker compose: `apt install docker-compose`

## Usage

- Clone this repo `git clone --recursive https://github.com/pabsan-0/yolov8-orin`
- Convert model from yolov8 to darknet: 
```
$ docker-compose run --rm ultralytics
# bash dl_weights.sh   # wget weights or get your own
# python3 gen_wts_yolov8.py --size 640 -w yolov8n.pt -o /weights
# rm labels.txt
```
- Run deepstream on the converted model (darknet->tensorrt is automatic):
```
$ cd DeepStream-Yolo
$ ls -l /usr/local/ | grep cuda  ## check cuda version
$ CUDA_VER=11.4 make -C nvdsinfer_custom_impl_Yolo # Compilation needs to be done on host
$ docker-compose run deepstream 
# bash pipe_sh/v4l2-docker.py  
```

  
## Snippets & links

- Check cuda version `ls -l /usr/local | grep cuda`
- Check deepstream version & health: `deepstream-app --version`
- Jetpack containers for jetson:
    - Pytorch: [l4t-pytorch](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/l4t-pytorch/tags)
    - Deepstream: [deepstream-l4t](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/deepstream-l4t/tags)



## Bugs and limitations

- Yolov8 may need a few extra dependencies for its built-in engine export 
    - `pip3 install --no-cache onnx>=1.12.0 onnxsim>=0.4.17 `
    - Get and install a wheel for onnxruntime for your Jetpack at https://elinux.org/Jetson_Zoo#ONNX_Runtime
- Gstreamer pipelines in C do not allow `'` characters
- Deepstream 6.2 sometimes requires specifying video format in pre-nvstreammux caps:
```
nvvideoconvert ! 'video/x-raw(memory:NVMM),format=NV12'
```

