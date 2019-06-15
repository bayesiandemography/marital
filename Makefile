
AGE_MAX = 75

.PHONY: all
all: data/births_cb.rda \
     documentation


## Births

data/births_cb.rda : data-raw/births_cb.R \
                     data-raw/census_data_20190327_5c9c35cc5727c.csv \
                     data-raw/census_data_20190327_5c9c35eb3d35a.csv
	Rscript $<


## Documentation

.PHONY: documentation
documentation:
	Rscript -e "devtools::document()"



.PHONY: clean
clean:
	rm -rf data
	mkdir data
