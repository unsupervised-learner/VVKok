FROM rocker/shiny

#copy dependencies into image
COPY ./requirements.R requirements.R

#install dependencies
RUN Rscript requirements.R

#set port to 3838
EXPOSE 3838