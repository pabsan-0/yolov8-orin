CUDA_VER?=11.4
ifeq ($(CUDA_VER),)
  $(error "CUDA_VER is not set")
endif


TARGET_DEVICE = $(shell gcc -dumpmachine | cut -f1 -d -)

NVDS_VERSION:=6.2

LIB_INSTALL_DIR?=/opt/nvidia/deepstream/deepstream-$(NVDS_VERSION)/lib/

PKGS:= gstreamer-1.0

CFLAGS+= -I/opt/nvidia/deepstream/deepstream/sources/includes \
		 -I/usr/local/cuda-$(CUDA_VER)/include 

CFLAGS+= $(shell pkg-config --cflags $(PKGS))

LIBS:= $(shell pkg-config --libs $(PKGS))

LIBS+= -L/usr/local/cuda-$(CUDA_VER)/lib64/ -lcudart -lm \
		-L$(LIB_INSTALL_DIR) \
		-lcuda -Wl,-rpath,$(LIB_INSTALL_DIR)

v4l2: v4l2.c
	$(CC) v4l2.c -Wall -g3 -o v4l2.o $(LIBS) $(CFLAGS) 

mp4: mp4.c
	$(CC) v4l2.c -Wall -g3 -o v4l2.o $(LIBS) $(CFLAGS) 

clean:
	rm *.o
