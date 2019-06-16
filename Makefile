
AGE_MAX = 75

.PHONY: all
all: data/births_cb.rda \
     data/births_un.rda \
     data/deaths_cb.rda \
     data/deaths_un.rda \
     data/marital_status_1990.rda \
     data/marital_status_2000_2010.rda \
     data/marriages_divorces.rda \
     data/remarriages.rda \
     data/conc_marital_status.rda \
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


## Population by marital status

data-raw/marital_status_df.rds : data-raw/marital_status_df.R \
                                 data-raw/NumberDeaths-20171201121407.xlsx
	Rscript $<

data/marital_status_1990.rda : data-raw/marital_status_1990.R \
                               data-raw/marital_status_df.rds
	Rscript $<

data/marital_status_2000_2010.rda : data-raw/marital_status_2000_2010.R \
                                    data-raw/marital_status_df.rds
	Rscript $<


## Marriages and divorces

data-raw/marriages_divorces_remarriages_df.rds : data-raw/marriages_divorces_remarriages_df.R \
                                                 data-raw/Marriage_Divorce.csv
	Rscript $<

data/marriages_divorces.rda : data-raw/marriages_divorces.R \
                              data-raw/marriages_divorces_remarriages_df.rds
	Rscript $<

data/remarriages.rda : data-raw/remarriages.R \
                       data-raw/marriages_divorces_remarriages_df.rds
	Rscript $<

data/conc_marital_status.rda : data-raw/conc_marital_status.R
	Rscript $<



## Documentation

.PHONY: documentation
documentation:
	Rscript -e "devtools::document()"



.PHONY: clean
clean:
	rm -rf data
	mkdir data
