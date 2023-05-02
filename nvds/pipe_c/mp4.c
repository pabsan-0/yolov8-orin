#include <gst/gst.h>
#include <glib.h>
#include <stdio.h>
#include <string.h>
#include <sys/time.h>
#include <unistd.h>
#include <stdlib.h>



int
main (int argc, char **argv)
{
    GMainLoop *loop = NULL;
    GstElement *pipeline = NULL;
    GError *error = NULL;

    /* Standard GStreamer initialization */
    gst_init (&argc, &argv);
    loop = g_main_loop_new (NULL, FALSE);

    const gchar *desc_templ = \
        "  uridecodebin uri=file:///media/viva-vigo-360.mp4 ! m.sink_0                                                    "
        "   nvstreammux name=m batch-size=1 width=360 height=360                                                          "
        " ! queue ! nvvideoconvert ! video/x-raw(memory:NVMM) ! nvinfer config-file-path=../coco_config_infer_primary.txt "
        " ! queue ! nvvideoconvert ! video/x-raw(memory:NVMM) ! nvdsosd ! nvvideoconvert ! autovideosink                  "
        ;;;;;;;;

    gchar *desc = g_strdup (desc_templ);
    pipeline = gst_parse_launch (desc, &error);
    if (error) {
        g_printerr ("pipeline parsing error: %s\n", error->message);
        g_error_free (error);
        return 1;
    }

    // Set the pipeline to "playing" state
    gst_element_set_state (pipeline, GST_STATE_PLAYING);

    // Wait till pipeline encounters an error or EOS
    g_print ("Running...\n");
    g_main_loop_run (loop);

    // Out of the main loop, clean up nicely
    g_print ("Returned, stopping playback\n");
    gst_element_set_state (pipeline, GST_STATE_NULL);
    g_print ("Deleting pipeline. Allow 2 seconds to shut down...\n");
    gst_object_unref (GST_OBJECT (pipeline));
    g_main_loop_unref (loop);
    return 0;
}
