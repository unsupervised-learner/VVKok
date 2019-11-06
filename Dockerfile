FROM rocker/shiny

#copy dependencies into image
COPY ./requirements.R requirements.R
