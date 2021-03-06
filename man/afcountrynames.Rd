% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/afcountrynames.r
\name{afcountrynames}
\alias{afcountrynames}
\title{return all africa country names
(may not need the function, given that I've saved as data afcountries)}
\usage{
afcountrynames(nameoriso3c = "name", filtercountries = NULL)
}
\arguments{
\item{nameoriso3c}{whether to return vector of 'name' or 'iso3c' or 'both'}

\item{filtercountries}{optional filter countries that are in 'gadm2' potential to add others}
}
\value{
character vector of african country names
}
\description{
return all africa country names
(may not need the function, given that I've saved as data afcountries)
}
\examples{

afcountrynames()

}
