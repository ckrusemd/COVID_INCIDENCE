FROM r-base

RUN apt-get update 
RUN apt-get -y install xml2 openssl libxml2 
RUN apt-get update
RUN apt-get -y install libxml2-dev libmariadb-dev
RUN apt-get update
RUN apt-get -y install libcurl4-gnutls-dev
 
RUN apt-get update && \
    apt-get install -y -qq \
    	r-cran-dplyr \
    	r-cran-tidyr \
    	r-cran-rvest \
        r-cran-xml \
    	#r-cran-XML \
    	r-cran-lubridate \
    	r-cran-data.table \
    	r-cran-openxlsx \
    	r-cran-stringr \
    	r-cran-readr \
    	#r-cran-beepr \
    	r-cran-quantmod \
    	r-cran-ggplot2 \
    	#r-cran-TTR \
    	r-cran-igraph \
    	r-cran-scales \
    	#r-cran-DBI \
    	#r-cran-RSQLite \
    	#r-cran-RCurl \
    	r-cran-httr \
    	r-cran-progress

RUN R -e "install.packages(c('devtools'),dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages(c('beepr'),dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages(c('TTR'),dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages(c('DBI'),dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages(c('RSQLite'),dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages(c('RCurl'),dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages(c('rPref'),dependencies=TRUE, repos='http://cran.rstudio.com/')"
#RUN R -e "install.packages('XML')"

# Bookdown specifics
RUN Rscript -e 'devtools::install_github("rstudio/bookdown")' \
  && wget -c https://github.com/jgm/pandoc/releases/download/1.19.2.1/pandoc-1.19.2.1-1-amd64.deb \
  && dpkg -i pandoc-1.19.2.1-1-amd64.deb

CMD ["Rscript","-e","'rmarkdown::render(\"COVID_INCIDENCE.Rmd\")'"]