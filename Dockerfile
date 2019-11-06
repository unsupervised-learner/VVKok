FROM rocker/shiny

#copy dependencies into image
COPY ./requirements.R requirements.R

#install dependencies
RUN Rscript requirements.R

#set port to 3838
EXPOSE 3838

#copy dashboard into container
COPY ./crimeDashboard.R crimeDashboard.R

#set app to run when container starts
CMD [ "Rscript", "crimeDashboard.R" ]