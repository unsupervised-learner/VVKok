FROM rocker/shiny

#copy dependencies into image
COPY ./requirements.R requirements.R

#install dependencies
RUN Rscript requirements.R