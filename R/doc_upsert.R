#' Create a new document or update an existing one
#'
#' @export
#' @template return
#' @param cushion A \code{\link{Cushion}} object. Required.
#' @param dbname (character) Database name. Required.
#' @param doc (character) Document content. Required.
#' @param docid (character) Document ID. Required.
#' @details Internally, this function attempts to update a document with the given name. \cr
#' If the document does not exist, it is created
#' @author George Kritikos
#' @examples \dontrun{
#' user <- Sys.getenv("COUCHDB_TEST_USER")
#' pwd <- Sys.getenv("COUCHDB_TEST_PWD")
#' (x <- Cushion$new(user=user, pwd=pwd))
#'
#' if ("sofadb" %in% db_list(x)) {
#'   invisible(db_delete(x, dbname="sofadb"))
#' }
#' db_create(x, 'sofadb')
#'
#' # create a document
#' doc1 <- '{"name": "drink", "beer": "IPA", "score": 5}'
#' doc_upsert(x, dbname="sofadb", doc1, docid="abeer")
#'
#' #update the document
#' doc2 <- '{"name": "drink", "beer": "lager", "score": 6}'
#' doc_upsert(x, dbname="sofadb", doc2, docid="abeer")
#'
#'
#' doc_get(x, dbname = "sofadb", docid = "abeer")
#' }
doc_upsert = function(cushion, dbname, doc, docid){
  tryCatch({
    #try to update, if failed (record doesn't exist), create new entry
    revs = db_revisions(cushion = cushion, dbname = dbname, docid = docid)
    return(
      doc_update(cushion = cushion, dbname = dbname, doc = doc, docid = docid, rev = revs[1])
    )
  }, error = function(e){
    return(
      doc_create(cushion = cushion, dbname = dbname, doc = doc, docid = docid)
    )
  })
}
