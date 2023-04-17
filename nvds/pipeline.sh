cd `git rev-parse --show-toplevel`

VIDEO_PATH = "$PWD/$1"

gst-launch-1.0 filesrc location="$VIDEO_PATH"                                                 \
    ! videoconvert ! 'video/x-raw,format=I420'                                                \
    ! queue leaky=2 max-size-buffers=100 max-size-time=0 max-size-bytes=1                     \
    ! nvvideoconvert ! 'video/x-raw(memory:NVMM),format=(string)I420,width=640,height=480'    \
    ! m.sink_0 nvstreammux name=m batch-size=1 width=480 height=480 nvbuf-memory-type=0       \
    ! nvvideoconvert ! nvinfer config-file-path="$PWD/nvds/coco_config_infer_primary.txt"     \
    ! nvmultistreamtiler width=640 height=480                                                 \
    ! nvvideoconvert ! nvdsosd ! filesink location=out.mp4                                    ;
