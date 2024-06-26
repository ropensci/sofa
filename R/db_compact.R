#' Request compaction of the specified database
#'
#' @export
#' @template all
#' @template return
#' @param dbname Database name. Required.
#' @details Compaction compresses the disk database file by performing the following
#' operations:
#'
#' - Writes a new, optimised, version of the database file, removing any unused
#'  sections from the new version during write. Because a new file is temporarily
#'  created for this purpose, you may require up to twice the current storage space
#'  of the specified database in order for the compaction routine to complete.
#' - Removes old revisions of documents from the database, up to the per-database
#'  limit specified by the _revs_limit database parameter.
#'
#' Compaction can only be requested on an individual database; you cannot compact all
#' the databases for a CouchDB instance. The compaction process runs as a background
#' process. You can determine if the compaction process is operating on a database by
#' obtaining the database meta information, the compact_running value of the returned
#' database structure will be set to true. See GET /{db}. You can also obtain a list of
#' running processes to determine whether compaction is currently running.
#' See "/_active_tasks"
#' @examples \dontrun{
#' user <- Sys.getenv("COUCHDB_TEST_USER")
#' pwd <- Sys.getenv("COUCHDB_TEST_PWD")
#' (x <- Cushion$new(user = user, pwd = pwd))
#' # db_compact(x, dbname = "iris")
#' }
db_compact <- function(cushion, dbname, as = "list", ...) {
  check_cushion(cushion)
  sofa_POST(paste0(cushion$make_url(), dbname, "/", "_compact"),
    as = as,
    cushion$get_headers(), cushion$get_auth(), ...
  )
}
