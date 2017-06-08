#' Title
#'
#' @param rss_feed is the url to the advarsels rss feed
#'
#' @return a data frame of the ten latest
#' @export
#'
#' @examples
#' library(alarmeringsapp)
#' alarms <- get_advarsel()

get_advarsel <- function(rss_feed = "https://alarmeringsapp.like.st/rss"){
  xml_data <- xml2::read_xml(rss_feed)
  xml_list <- xml2::as_list(xml_data)
  my_subset <- which(names(xml_list$channel) == "item")
  my_items <- xml_list$channel[my_subset]

  items_df <- purrr::map_df(my_items, function(x){

    title <- unlist(x$title)
    description <- unlist(x$description)
    pubDate <- unlist(x$pubDate)

    tibble::tibble(
      title,
      description,
      pubDate
    )

  })

  fix_encoding <- function(string){
    for(i in 1:nrow(encoding_table)){

      tryCatch({
        string <- stringr::str_replace_all(string,
                                           encoding_table$entity.name[i],
                                           encoding_table$character[i])

      }, error=function(e){})
    }

    string <- stringr::str_replace_all(string, " ,", ",")

    return(string)

  }

  items_df$title <- fix_encoding(items_df$title)
  items_df$description <- fix_encoding(items_df$description)

  items_df$pubDate <- anytime::anytime(items_df$pubDate)

  return(items_df)
}
