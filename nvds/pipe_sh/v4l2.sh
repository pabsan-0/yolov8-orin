#! /bin/bash

gst-launch-1.0 v4l2src device=/dev/video0  ! video/x-raw,format=YUY2,width=160                                            \
    ! queue leaky=2 max-size-buffers=100 max-size-time=0 max-size-bytes=1                                                 \
    ! queue ! nvvideoconvert ! 'video/x-raw(memory:NVMM),format=NV12'                                                     \
    ! queue ! m.sink_0 nvstreammux name=m batch-size=1 width=160 height=160                                               \
    ! queue ! nvvideoconvert ! 'video/x-raw(memory:NVMM)' ! nvinfer config-file-path="/ws/coco_config_infer_primary.txt"  \
    ! queue ! nvvideoconvert ! 'video/x-raw(memory:NVMM)' ! nvdsosd ! nvvideoconvert ! autovideosink sync=0 async=0       ;
