.PHONY: build push test


test:
	make -C build test
	make -C ssh test
	make -C gdb test
	make -C kernel test
	make -C qemu test

check:
	docker rm -f toshokan_qemu 2>&1 || :
	docker network rm toshokan_net || :
	docker network create --driver bridge toshokan_net
	docker run -d --name toshokan_qemu --network toshokan_net -P livadk/toshokan_qemu
	docker run -i --rm --network toshokan_net livadk/toshokan_ssh ssh toshokan_qemu exit 0

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
