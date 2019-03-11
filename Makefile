.PHONY: build push test


test:
	make -C build test
	make -C ssh test
	make -C gdb test
	make -C kernel test
	make -C qemu test

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
	make -C kernel push
	make -C qemu push
