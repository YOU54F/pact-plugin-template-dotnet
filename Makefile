PROJECT=dotnet-template
APP_NAME=GrpcPactPlugin
PLUGIN_VERSION?=$(shell ./script/bump.sh -p "v-" -l)

clean:
	rm -rf bin
	rm -rf obj
	rm -rf build

update_manifest:
	@echo ${PLUGIN_VERSION} && variable=${PLUGIN_VERSION}; jq --arg variable "$$variable" '.version = $$variable' pact-plugin.json > pact-plugin.json

proto: build

build:
	dotnet build
	
run_local:
	dotnet run

run_build:
	./bin/Debug/net6.0/GrpcPactPlugin

test_build:
	./bin/Debug/net6.0/GrpcPactPlugin & _pid=$$!; \
    sleep 3 && ./evans.sh; kill $$_pid

.PHONY: bin build


compile: clean
	dotnet publish -o build/${PLATFORM}/${ARCH} --arch ${ARCH} --os $(PLATFORM)
	cp build/${PLATFORM}/${ARCH}/${APP_NAME} .

compress:
	gzip -c build/${PLATFORM}/${ARCH}/${PROJECT} > dist/release/pact-${PROJECT}-plugin-${PLATFORM}-${ARCH}.gz

prepare: compress generate_manifest


install_local: compile move_to_plugin_folder

move_to_plugin_folder:
	mkdir -p ${HOME}/.pact/plugins/pact-${PROJECT}-plugin-${PLUGIN_VERSION}
	mv ${APP_NAME} ${HOME}/.pact/plugins/pact-${PROJECT}-plugin-${PLUGIN_VERSION}
	cp pact-plugin.json ${HOME}/.pact/plugins/pact-${PROJECT}-plugin-${PLUGIN_VERSION}

generate_manifest:
	variable=${PLUGIN_VERSION}; jq --arg variable "$$variable" '.version = $$variable' pact-plugin.json > dist/release/pact-plugin.json
	cat dist/release/pact-plugin.json

compile_move: compile move_to_plugin_folder

PLATFORM 				:=
ARCH 				:=
ifeq '$(findstring ;,$(PATH))' ';'
	PLATFORM=windows
	ifeq ($(PROCESSOR_ARCHITECTURE),AMD64)
		ARCH=aarch64
	endif
	ifeq ($(PROCESSOR_ARCHITECTURE),x86)
		ARCH=x64
	endif
	UNAME_P := $(shell uname -m)
	ifeq ($(UNAME_P),x86_64)
		ARCH=x64
	endif
	ifneq ($(filter arm%,$(UNAME_P)),)
		ARCH=aarch64
	endif
	ifneq ($(filter aarch64%,$(UNAME_P)),)
		ARCH=aarch64
	endif
else
	PLATFORM:=$(shell uname 2>/dev/null || echo Unknown)
	PLATFORM:=$(patsubst CYGWIN%,Cygwin,windows)
	PLATFORM:=$(patsubst MSYS%,MSYS,windows)
	PLATFORM:=$(patsubst MINGW%,MSYS,windows)
	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S),Linux)
		PLATFORM=linux
	endif
	ifeq ($(UNAME_S),Darwin)
		PLATFORM=osx
	endif
	UNAME_P := $(shell uname -m)
	ifeq ($(UNAME_P),x86_64)
		ARCH=x64
	endif
	ifneq ($(filter arm%,$(UNAME_P)),)
		ARCH=arm64
	endif
	ifneq ($(filter aarch64%,$(UNAME_P)),)
		ARCH=arm64
	endif
endif


detect_os:
	@echo $(shell uname -s)
	@echo $(shell uname -m)
	@echo $(shell uname -p)
	@echo $(shell uname -p)
	@echo $(PLATFORM) $(ARCH)

x-plat:
	dotnet publish -o build/osx/aarch64/${PROJECT} --arch arm64 --os osx
	dotnet publish -o build/osx/x86_64/${PROJECT} --arch x64 --os osx
	dotnet publish -o build/linux/aarch64/${PROJECT} --arch arm64 --os linux
	dotnet publish -o build/linux/x86_64/${PROJECT} --arch x64 --os linux
	dotnet publish -o build/windows/aarch64/${PROJECT} --arch arm64 --os win
	dotnet publish -o build/windows/x86_64/${PROJECT} --arch x64 --os win