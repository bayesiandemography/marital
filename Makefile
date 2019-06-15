
AGE_MAX = 75

.PHONY: all
all: data/births_cb.rda \
     data/births_un.rda \
     data/deaths_cb.rda \
     data/deaths_un.rda \
     documentation


## Births

data/births_cb.rda : data-raw/births_cb.R \
                     data-raw/census_data_20190327_5c9c35cc5727c.csv \
                     data-raw/census_data_20190327_5c9c35eb3d35a.csv
	Rscript $<

data/births_un.rda : data-raw/births_un.R \
                     data-raw/NumberBirthsAgeMother-20171130020714.xlsx
	Rscript $< --denom $(DENOM)


## Deaths

data/deaths_cb.rda : data-raw/deaths_cb.R \
                     data-raw/census_data_20190327_5c9c35cc5727c.csv \
                     data-raw/census_data_20190327_5c9c35eb3d35a.csv
	Rscript $<

data/deaths_un.rda : data-raw/deaths_un.R \
                     data-raw/NumberDeaths-20171201121407.xlsx
	Rscript $< --age_max $(AGE_MAX)


## Documentation

.PHONY: documentation
documentation:
	Rscript -e "devtools::document()"



.PHONY: clean
clean:
	rm -rf data
	mkdir data
