#! /bin/bash

gst-launch-1.0 uridecodebin uri=file:///media/viva-vigo-360.mp4 ! m.sink_0                                                          \
      nvstreammux name=m batch-size=1 width=360 height=360                                                                          \
    ! queue ! nvvideoconvert ! 'video/x-raw(memory:NVMM)' ! nvinfer config-file-path="/ws/coco_config_infer_primary.txt"            \
    ! queue ! nvvideoconvert ! 'video/x-raw(memory:NVMM)' ! nvdsosd ! nvvideoconvert ! videoconvert ! autovideosink;
