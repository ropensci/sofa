all: move rmd2md

move:
	cp inst/vign/sofa_vignette.md vignettes

rmd2md:
	cd vignettes;\
	mv sofa_vignette.md sofa_vignette.Rmd
