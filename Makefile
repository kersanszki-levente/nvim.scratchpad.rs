.PHONY: testenv

testenv:
	XDG_CONFIG_HOME="$(shell pwd)" NVIM_APPNAME=testenv nvim
