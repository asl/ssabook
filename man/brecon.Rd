\name{brecon}
\alias{brecon}
\docType{data}
\title{Brecon Beacons}
\description{
  The image of Brecon Beacons national park.
}
\usage{data(brecon)}
\format{
  A double matrix with integer values.
}
\details{  
  The test DTM of a region in South Wales, UK. The DTM is 80 x 100, and
  it includes the Brecon Beacons national park. The point (80, 1) lies
  in a neighborhood of Port Talbot, (80, 100) lies in a neighborhood of
  Newport, and (1, 100) is near Whitney-on-Wye.
}
\examples{
# The data was obtaned as follows
\dontrun{
library("raster")
UK <- getData("alt", country = "GB", mask = TRUE)
brecon <- crop(UK, extent(UK, 1040, 1119, 590, 689))
brecon <- as.matrix(brecon)
}
}
\keyword{datasets}


