library(lubridate)

# Merging in assignment probabilities -------------------------------------

setwd("jordan_current_data/")
probabilities_filenames=list.files(pattern="*treatmentprobabilities.csv", recursive = F)
probabilities=map(probabilities_filenames,
                  read_csv)
setwd("../")

date_list=map_dbl(probabilities_filenames,
                  function(name) as_date(name[1:10])[1])

start_date=as_date(min(date_list))

nearest_date_probas = function(check_date, stratum){
    if (check_date < start_date) {
        return(tibble("1"=.25, "2"=.25, "3"=.25, "4"=.25))
    } else {
        nearest_prior_date=which.max(date_list - 1000*(date_list>check_date))
        return(probabilities[[nearest_prior_date]][stratum,])
    }
}

merged_data=tibble(date = lubridate::ymd(priordata$date),
                   Y = as.integer(priordata$Y),
                   D = priordata$D,
                   stratum=as.integer(priordata$X))

merged_data = map2(merged_data$date, merged_data$stratum, nearest_date_probas) %>% 
    bind_rows %>% 
    bind_cols(merged_data)
