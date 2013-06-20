.onAttach <- function(...) {
  packageStartupMessage("
    \nStart CouchDB on your command line by typing 'couchdb' 
    \nThen start Elasticsearch if using by opening a new terminal tab/window, navigating to where it was installed and starting 
    \nOn my Mac this is: cd /usr/local/elasticsearch then bin/elasticsearch -f
    \nNew to sofa? Tutorial at https://github.com/schamberlain/sofa. 
    \nUse suppressPackageStartupMessages() to suppress these startup messages in the future\n
  ")
} 