.PHONY: test
test: fmt
	mojo test -I .

.PHONY: checkout
checkout:
	./checkout_remote_modules.sh

.PHONY: build
build: fmt
	@mkdir -p dist
	@mojo package arrow_schema -o dist/arrow_schema.mojopkg

.PHONY: clean
clean: 
	rm -rf dist

.PHONY: fmt
fmt: 
	@mojo format arrow_schema test flatbuffers

# .PHONY: setup
# setup:
# 	@uv venv
# 	@echo "\n***\nInstalling python dependencies\n***\n"
# 	@uv pip install -r requirements.txt
# 	@echo "\n***\nInstalling pre-commit hooks\n***\n"
# 	@./.venv/bin/pre-commit install
# 	@echo "\n***\nRunning tests (they should all pass)\n***\n"
# 	@source .venv/bin/activate && mojo test -I .