.PHONY: build push

build:
	make -C build build
	make -C sftp build
	make -C kernel build
	make -C qemu build

push:
	make -C build push
	make -C sftp push
	make -C kernel push
	make -C qemu push