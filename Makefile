.PHONY: build push

build:
	make -C build build
	make -C ssh build
	make -C qemu build
	make -C gdb build
	make -C kmod_build build

push:
	make -C build push
	make -C ssh push
	make -C qemu push
	make -C gdb push
	make -C kmod_build push
