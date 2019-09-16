
AGE_MAX = 75

.PHONY: all
all: data/births_un.rda \
     data/deaths_un.rda \
     data/census.rda \
     data/popn_sruvey.rda \
     data/marriages_divorces.rda \
     data/remarriages.rda \
     data/conc_marital_status.rda \
     documentation


## UN birth estimates

data/births_un.rda : data-raw/births_un.R \
                     data-raw/NumberBirthsAgeMother-20171130020714.xlsx
	Rscript $<


## UN death estimates

data/deaths_un.rda : data-raw/deaths_un.R \
                     data-raw/NumberDeaths-20171201121407.xlsx
	Rscript $<


## Census counts

data/census.rda : data-raw/census.R \
                  data-raw/UNdata_Export_20180121_001507260.csv
                  data-raw/UNdata_Export_20190614_062418893.csv
	Rscript $<


## Population survey

data/popn_survey.rda : data-raw/popn_survey.R \
                       data-raw/china_statistical_yearbook/CSYB2006_Table4.11.xls \
                       data-raw/china_statistical_yearbook/cyb2016_table_2.13.csv
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
