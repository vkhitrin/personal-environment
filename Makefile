DISTRO_ID := "test"
ifeq ($(OS),Windows_NT)
	$(error "Windows is not supported.")
else
	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S),Linux)
		ifeq ($(shell test -f /etc/os-release && echo -n "yes"),yes)
			DISTRO_ID := $(shell grep '^ID=' /etc/os-release | cut -d'=' -f2)
			include os/linux/$(DISTRO_ID)/Makefile
		else
			DISTRO_ID := "unknown"
		endif
	endif
	ifeq ($(UNAME_S),Darwin)
		DISTRO_ID := macOS
		include os/darwin/$(DISTRO_ID)/Makefile
	endif
endif
