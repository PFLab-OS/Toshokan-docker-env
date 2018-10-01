.PHONY: build push

build:
	make -C build build
	make -C ssh build
	make -C kernel build
	make -C qemu build
	make -C gdb build

push:
	make -C build push
	make -C ssh push
	make -C kernel push
	make -C qemu push
	make -C gdb push
