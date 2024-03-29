##############################################
#Invoke this script from the terminal as follows:
#RScript --vanilla command_line_app.R data/test_data.csv 600
#the first argument is the input file of prior data
#the second argument is the number of units in the current wave
##############################################

source("ReadDataApp.R")
source("modified_thompson.R")
source("optimal_stopping.R")


# Reading in data and arguments
command_arguments = commandArgs(trailingOnly = T)
datapath = command_arguments[1]
Nt = as.integer(command_arguments[2])


priordata = ReadDataApp(datapath)

###########################
# Calculating treatment assignment
Dt = DtchoiceThompson_modified(priordata$Y,
                               priordata$D,
                               priordata$k,
                               Nt = Nt)


filename = paste("data/", Sys.Date(), "_treatment_assignment.csv", sep = "")
write_csv(tibble(treatment = Dt), path = filename)


#######################
# knitting the dashboard
library(rmarkdown)
Sys.setenv(RSTUDIO_PANDOC = "/Applications/RStudio.app/Contents/MacOS/pandoc")
render("reproducible_analysis_precision_ag.Rmd",
       params = list(datapath = datapath))


####################
# Calculating expected reduction of regret
regret_reduction = expected_return(priordata$Y,
                                   priordata$D,
                                   priordata$k,
                                   Nt = Nt)

sink(paste("data/", Sys.Date(), "_regret_reduction.txt", sep = ""))
print("Expected reduction of regret: ")
print(regret_reduction)
sink()
