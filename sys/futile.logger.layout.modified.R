# Get name of a parent function in call stack
# @param .where: where in the call stack. -1 means parent of the caller.
.get.parent.func.name <- function(.where) {
  the.function <- tryCatch(deparse(sys.call(.where - 1)[[1]]), 
                           error=function(e) "(shell)")
  the.function <- ifelse(
    length(grep('flog\\.',the.function)) == 0, the.function, '(shell)')
  
  the.function
}

# Generates a list object, then converts it to JSON and outputs it
layout.json <- function(level, msg, id='', ...) {
  if (!requireNamespace("jsonlite", quietly=TRUE))
    stop("layout.json requires jsonlite. Please install it.", call.=FALSE)
  
  the.function <- .get.parent.func.name(-3) # get name of the function 
  # 3 deep in the call stack
  
  output_list <- list(
    level=jsonlite::unbox(names(level)),
    timestamp=jsonlite::unbox(format(Sys.time(), "%Y-%m-%d %H:%M:%S %z")),
    msg=jsonlite::unbox(msg),
    func=jsonlite::unbox(the.function),
    additional=...
  )
  paste0(jsonlite::toJSON(output_list, simplifyVector=TRUE), '\n')
}
