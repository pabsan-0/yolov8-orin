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

```
git clone --recursive https://github.com/pabsan-0/yolov8-orin
```

### YOLOv8

Use to train, prepare and test Yolov8 in the Ultralytics environment.

- Workspace: `yolo/` 
- Usage:
    - If using external weights, dump them into `yolo/`
    - Match ultralytics repo dependencies via `docker-compose run ultralytics`
    - Convert your model for deepstream:
        - Built-in export to `.engine`: `yolo export model=yolov8n.pt format=engine device=0`
        - External export to `wts+cfg`: `python3 gen_wts_yoloV8.py -w yolov8n.pt` (weitghts file should start with `yolov8`)

The `gen_wts_yoloV8.py` script has been snatched from [DeepStream-Yolo](https://github.com/marcoslucianops/DeepStream-Yolo). The dockerfile was created by hand as there was none available back then, see [ultralytics/ultralytics#2025](https://github.com/ultralytics/ultralytics/issues/2025)


### Deepstream

Use to deploy your detection model in a deepstream pipeline.

- Workspace: `nvds/` 
- Usage:
    - Edit `coco_config_infer_primary.txt`:
        - If you have an `.engine`: set its name in the file.
        - If you have `wts+cfg`: set their names in the file. An engine will be generated if the engine field in the file does not exist. 
    - Match Deepstream dependencies via `docker-compose run ultralytics` (optional for Jetson)
    - Build the DeepStream-Yolo submodule with: `CUDA_VER=11.4 make -C nvdsinfer_custom_impl_Yolo`
    - Test the inference pipeline by running `bash nvds/pipeline.sh`  
  
## Snippets & links

- Check cuda version `ls -l /usr/local | grep cuda`
- Check deepstream version & health: `deepstream-app --version`
- Jetpack containers for jetson:
    - Pytorch: [l4t-pytorch](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/l4t-pytorch/tags)
    - Deepstream: [deepstream-l4t](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/deepstream-l4t/tags)

## Bugs and limitations

- Yolov8 needs a few extra dependencies for the engine export:
    - `pip3 install --no-cache onnx>=1.12.0 onnxsim>=0.4.17 `
    - Get and install a wheel for onnxruntime for your Jetpack at https://elinux.org/Jetson_Zoo#ONNX_Runtime
- Deepstream does not work currently on Orin. Probably related to missing dependencies since docker images for NVDS 6.2 do NOT have dev requisites prepackaged.


<!-- 

```
sudo apt install -y libgstreamer1.0-0 gstreamer1.0-tools gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav libgstrtspserver-1.0-0 libjansson4
```

-->