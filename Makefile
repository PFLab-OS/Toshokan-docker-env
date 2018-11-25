.PHONY: build push

build:
	make -C build build
	make -C ssh build
	make -C gdb build
	make -C kernel build
	make -C qemu build

push:
	make -C build push
	make -C ssh push
	make -C gdb push
	make -C kernel build
	make -C qemu push
