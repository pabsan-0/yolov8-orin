#! /bin/bash

VIDEO_PATH="$PWD/yolo/media/videoplayback.mp4"

gst-launch-1.0 -ve filesrc location="$VIDEO_PATH"                                             \
    ! qtdemux ! av1dec                                                                        \
    ! queue leaky=2 max-size-buffers=100 max-size-time=0 max-size-bytes=1                     \
    ! nvvideoconvert ! 'video/x-raw,format=I420'                                              \
    ! nvvideoconvert ! 'video/x-raw(memory:NVMM)'                                             \
    ! m.sink_0 nvstreammux name=m batch-size=1 width=640 height=640 nvbuf-memory-type=0       \
    ! nvvideoconvert ! nvinfer config-file-path="$PWD/nvds/coco_config_infer_primary.txt"     \
    ! nvvideoconvert ! nvdsosd ! filesink location=out.mp4                                    ;
