#' @title R client for CouchDB.
#'
#' @description Relax.
#'
#' @section About sofa:
#' \pkg{sofa} provides an interface to the NoSQL database CouchDB
#' (\url{http://couchdb.apache.org}). Methods are provided for managing
#' databases within CouchDB, including creating/deleting/updating/transferring,
#' and managing documents within databases. One can connect with a local
#' CouchDB instance, or a remote CouchDB databases such as Cloudant
#' (\url{https://cloudant.com}). Documents can be inserted directly from
#' vectors, lists, data.frames, and JSON.
#'
#' @section Client connections:
#' All functions take as their first parameter a client connection object,
#' or a \strong{cushion}. Create the object with \code{\link{Cushion}}. You
#' can have multiple connection objects in an R session.
#'
#' @section CouchDB versions:
#' \pkg{sofa} was built assuming CouchDB version 2 or greater. Some
#' functionality of this package will work with versions < 2, while
#' some may not (mango queries, see \code{\link{db_query}}). I don't
#' plan to support older CouchDB versions per se.
#'
#' @importFrom R6 R6Class
#' @importFrom jsonlite fromJSON toJSON unbox
#' @importFrom crul HttpClient
#' @name sofa-package
#' @aliases sofa
#' @docType package
#' @title R client for CouchDB
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com}
#' @keywords package
NULL
