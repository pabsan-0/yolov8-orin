** Ultralytics container **

Use this container to convert torch .pt weights to something that can be converted into TensorRT.

# Use this wrapper around wget to download sample yolov8n
./dl_weights.sh 

# Use something like this to convert weights to darknet-like .wts
python3 gen_wts_yoloV8.py -w /weights/yolov8n.pt -s 640 640 -o /weights/v