#! /usr/bin/python3

from ctypes import *
import sys

import gi
gi.require_version('Gst', '1.0')
gi.require_version('GObject', '2.0')
from gi.repository import Gst, GObject, GLib


if __name__ == "__main__":
    
    Gst.init(sys.argv[1:])
    loop = GLib.MainLoop()
    
    
    pipe_desc = f"""
        v4l2src device=/dev/video0  ! video/x-raw,format=YUY2,width=160
        ! queue leaky=2 max-size-buffers=100 max-size-time=0 max-size-bytes=1
        ! queue ! nvvideoconvert ! video/x-raw(memory:NVMM),format=NV12
        ! queue ! m.sink_0 nvstreammux name=m batch-size=1 width=160 height=160
        ! queue ! nvvideoconvert ! video/x-raw(memory:NVMM) ! nvinfer config-file-path=../coco_config_infer_primary.txt
        ! queue ! nvvideoconvert ! video/x-raw(memory:NVMM) ! nvdsosd ! nvvideoconvert ! autovideosink sync=0 async=0
        """

    # Parsing and setting stuff up
    pipeline = Gst.parse_launch(pipe_desc)

    # Start the pipeline
    pipeline.set_state(Gst.State.PLAYING)
    try:
        # Blocking run call 
        loop.run()
    except Exception as e:
        print(e)
        loop.quit()
    

    # Python has a garbage collector, but normally we'd clean up here
    pipeline.set_state(Gst.State.NULL)
    del pipeline
