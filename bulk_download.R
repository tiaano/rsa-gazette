# This script downloads all available Legal Gazettes from the wibsite

library(rvest)

# Function to download all PDF on the current page
# +- 20 PDFs per page

gazette_download <- function(x){
  
    print(paste("start downloading page",x))
    
    # Set base URL
    legal <- read_html(paste0("http://www.gpwonline.co.za/Gazettes/Pages/Published-Legal-Gazettes.aspx?p=",x))
    
    # Get the actual PDF download URL from the html table
    gg_url <- legal %>% 
      html_nodes(xpath='//li/div/div/div/a') %>% html_attr(name = 'href') %>% `[`(1:20)
    
    # Some liks contain special characters, so we need to do a URL encode
    gg_url <- unlist(Map(URLencode,gg_url))
    
    # Get the PDF name from the html table
    gg_name <- legal %>% 
      html_nodes(xpath='//li/div/div/div/a') %>% html_text() %>% `[`(1:20)
    
    # Get the PDF date from the html table
    gg_date <- legal %>% 
      html_nodes(xpath='//li/div/div/div[2]') %>% html_text() %>% `[`(1:20)
    
    # Set a vector with destination path where we should download the PDFs
    destinations <- paste0("<your file path>/",gg_name," - ",gsub(pattern = "/","",gg_date),".pdf")
    
    # Use "Map" to download PDFs
    Map(function(u, d) download.file(u, d, mode="wb",quiet = T), gg_url, destinations)

}
# Preset the number of pages
# ! TODO: Scrape number of pages
page_list <- c(1:43)

# Start download
Map(gazette_download,page_list)
