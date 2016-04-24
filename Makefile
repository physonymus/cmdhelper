# Makefile for cmdhelper.py

CURRENTVERSION = `python -c 'import cmdhelper; print cmdhelper.__version__'`

build:
	@echo 'Building ...'
	@python setup.py sdist
	@echo ''
	@echo 'Testing installation ...'
	@virtualenv --clear test
	@. test/bin/activate; cd test; pip install ../dist/`ls ../dist | tail -1`; pip show cmdhelper; python -c 'import cmdhelper; print "\nFound version",cmdhelper.__version__'
	@rm -rf test

newversion:
	@bumpversion patch cmdhelper.py
	@python -c 'import cmdhelper; print "New version is",cmdhelper.__version__'

test-upload:
	@python setup.py sdist upload -r test
	@echo ''
	@echo 'Testing installation from test PyPI ...'
	@virtualenv --clear test
	@. test/bin/activate; cd test; pip install -i https://testpypi.python.org/pypi cmdhelper; pip show cmdhelper; python -c 'import cmdhelper; print "\nFound version",cmdhelper.__version__'
	@rm -rf test
	@firefox https://testpypi.python.org/pypi

upload:
	@python setup.py sdist upload -r pypi
	@echo ''
	@echo 'Testing installation from PyPI ...'
	@virtualenv --clear test
	@. test/bin/activate; cd test; pip install cmdhelper; pip show cmdhelper; python -c 'import cmdhelper; print "\nFound version",cmdhelper.__version__'
	@rm -rf test
	@firefox https://pypi.python.org/pypi

tag:
	@echo 'Commit and tag new version ...'
	@git diff
	@git commit -a -m "Version $(CURRENTVERSION)"
	@git tag -a -m "v$(CURRENTVERSION) as uploaded to PyPI" v$(CURRENTVERSION)
	@git push
	@git push origin v$(CURRENTVERSION)