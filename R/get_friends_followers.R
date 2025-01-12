#' Download the friends and followers in a period of time
#'
#' This download a time series with the evolution of friends, followers, listed, statuses, likes
#' and the created date of the account
#' @param screen.name A character vector with an Twitter user
#' @import readr
#' @import crayon
#' @import dplyr
#' @export
#' @examples
#' get_friends_followers(screen.name = "SergioMassa")
#' get_friends_followers(screen.name = c("SergioMassa", "dalesmm"))
#'
#' @return This function returns a \code{data.frame} including columns:
#' \itemize{
#' \item date
#' \item followers_count
#' \item friends_count
#' \item listed_count
#' \item statuses_count
#' \item favourites_count
#' \item account_created_at
#' }
#'
#' @export
#' @seealso \link[rtweet]{get_followers}
#' @seealso \link[rtweet]{get_friends}

get_friends_followers <- function(screen.name) {

  data_politicxs <- download_list()

  if(length(screen.name) == 1){

    data_crec <- read_csv("https://github.com/guadag12/configuration_db/raw/main/amount_followers.csv",
                          locale = locale(encoding = "Latin1"))
    data_crec <- data.frame(lapply(data_crec, as.character), stringsAsFactors=FALSE)

    data <- data_crec[data_crec$screen_name == screen.name, ]


    }
    else{
      j = 1
      for(i in screen.name){
        if(!i %in% data_politicxs$screen_name ){
          warning(paste0(i, " is not in the list of Politicians on TwitteR (list: https://github.com/guadag12/polentw/raw/master1/data/politicxs_data.rda ). You must try download the tweets with rtweet package"))
        }
        data_crec <- read_csv("https://github.com/guadag12/configuration_db/raw/main/amount_followers.csv",
                              locale = locale(encoding = "Latin1"))
        data_crec <- data.frame(lapply(data_crec, as.character), stringsAsFactors=FALSE)

        data_crec <- data_crec[data_crec$screen_name == screen.name, ]

          if(j == 1) {
            data <- data_crec[0,]
            data <- dplyr::bind_rows(data, data_crec)
            j=j+1

          }
          else {
            data <- dplyr::bind_rows(data, data_crec)
            j=j+1 }

      }
    }
  data <- data[, c("screen_name","date", "followers_count", "friends_count", "listed_count", "statuses_count",
                   "favourites_count")]
  return(data)

  cat(crayon::green$bold("Congrats, the data of", screen.name, "is download" ))
}

