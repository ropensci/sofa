PACKAGE := $(shell grep '^Package:' DESCRIPTION | sed -E 's/^Package:[[:space:]]+//')
RSCRIPT = Rscript --no-init-file

all: move rmd2md

move:
	cp inst/vign/sofa.md vignettes

rmd2md:
	cd vignettes;\
	mv sofa.md sofa.Rmd

install: doc build
	R CMD INSTALL . && rm *.tar.gz

build:
	R CMD build . --no-build-vignettes

doc:
	${RSCRIPT} -e "devtools::document()"

eg:
	${RSCRIPT} -e "devtools::run_examples(run = TRUE)"

test:
	${RSCRIPT} -e "devtools::test()"

check: build
	_R_CHECK_CRAN_INCOMING_=FALSE R CMD CHECK --as-cran --no-manual `ls -1tr ${PACKAGE}*gz | tail -n1`
	@rm -f `ls -1tr ${PACKAGE}*gz | tail -n1`
	@rm -rf ${PACKAGE}.Rcheck

check_windows:
	${RSCRIPT} -e "devtools::check_win_devel(); devtools::check_win_release()"

readme:
	${RSCRIPT} -e "knitr::knit('README.Rmd')"
