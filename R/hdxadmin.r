#' hdx admin layers starting to looking at downloading
#'
#' #todo vectorise
#'
#' @param country a character vector of country names
#'
#'
#' @examples
#'
#' hdxadmin("nigeria")
#'
#' @return not sure yet
#' @export
#'
hdxadmin <- function(country) {


    iso3clow <- tolower(country2iso(country))

    #querytext <- paste0('vocab_Topics:("common operational dataset - cod" AND "administrative divisions") AND groups:', iso3clow)
    querytext <- paste0('vocab_Topics:("common operational dataset - cod" AND "gazetteer") AND groups:', iso3clow)


    rhdx::set_rhdx_config()
    datasets_list <- rhdx::search_datasets(fq = querytext)

    ds <- datasets_list

    #hoping that it just returns a single dataset (with multiple resources)

    list_of_rs <- rhdx::get_resources(ds[[1]])

    list_of_rs

    #lapply(ken, function(x) get_resource_format(x))

    #[1] "zipped shapefiles"
    #[1] "zipped geodatabase"

    # pull_dataset("administrative-boundaries-cod-mli") %>%
    #          get_resource(3) %>%
    #          read_resource(download_folder=getwd()) -> malishp
    #
    # plot(sf::st_geometry(malishp))

    # alternative approach using name of resource
    # is naming consistent ?
    ds <- pull_dataset("administrative-boundaries-cod-mli")

    # for Mali is 3rd resource
    # TODO find better way of selecting from dataset list
    re <- get_resource(ds, 3)

    # find which layers in file
    mlayers <- get_resource_layers(re, download_folder=getwd())

    # next can I search for adm1 3 etc. in name field of the result
    # to get the layer I want

    #mlayers$name[ grep("adm2",mlayers$name) ]
    #using paste from admin_level
    level <- 2
    layername <- mlayers$name[ grep(paste0("adm",level),mlayers$name) ]
    # this relies on all country layers having adm* in their names

    # read layer using layername
    sflayer <- read_resource(re, layer=layername, download_folder=getwd())

    plot(sf::st_geometry(sflayer))

    # when I do directly from sf (see below)
    # seems to be problem opening a layer from a zipped shapefile by name
    # somehow rhdx gets around that


    # TODO will it work for geodatabase ?


}

# rhdx seems to read the first layer if one isn't specified
# read_hdx_vector <- function(file = NULL, layer = NULL, zipped = TRUE, ...) {
#     check_packages("sf")
#     if (zipped)
#         file <- file.path("/vsizip", file)
#     if (is.null(layer)) {
#         layer <- sf::st_layers(file)[[1]][1]
#         message("reading layer: ", layer, "\n")
#     }
#     sf::read_sf(dsn = file, layer = layer, ...)
# }


#sf to find layers in a file
#mlayers <- sf::st_layers(file.path("/vsizip","mli_adm_1m_dnct_2019_shp.zip"))

#reads first layer by default if not specified
sfmali <- sf::read_sf(file.path("/vsizip","mli_adm_1m_dnct_2019_shp.zip"))

sfmali <- sf::read_sf(file.path("/vsizip","mli_adm_1m_dnct_2019_shp.zip", layer=mlayers$name[2]))
#still problem reading 2nd layr from zip
#Error: Cannot open "/vsizip/mli_adm_1m_dnct_2019_shp.zip/mli_admbnda_adm1_1m_dnct_20190802"; The file doesn't seem to exist.

plot(sf::st_geometry(sfmali))

# rhdx has some useful code for querying format of resources from hdx and
# determining how to open them

# using gazetteer
# > hdxadmin("nigeria")
# [[1]]
# <HDX Resource> 0bc2f7bb-9ff6-40db-a569-1989b8ffd3bc
# Name: nga_admbnda_osgof_eha_itos.gdb.zip
# Description: Administrative level 0 (country), 1 (state), 2 (local government area), 3 (wards - northeast Nigeria), and  senatorial district boundary geodatabase
# Size: 6706778
# Format: GEODATABASE
#
# ...
#
# [[3]]
# <HDX Resource> aa69f07b-ed8e-456a-9233-b20674730be6
# Name: nga_adm_osgof_20190417_SHP.zip
# Description: Administrative level 0 (country), 1 (state), 2 (local government area), 3 (wards - northeast Nigeria), and  senatorial districts boundary shapefiles
# Size: 7491434
# Format: ZIPPED SHAPEFILES

#for Nigeria using tag:administrative divisions just returning this topojson probably not what I want
# hdxadmin("nigeria")
# [[1]]
# <HDX Resource> e13316a7-1380-4676-abdc-bd5127577371
# Name: COD_NGA_Admin3.topojson
# Description: This dataset is of simplified geometries from COD live services deployed Sept.  2019. To preview, download from link and load in https://mapshaper.org. Methodology: Simplification methods applied from ESRI libraries using Python, Node.js and Mapshaper.js and based on adapted procedures for best outcomes preserving shape, topology and attributes. These data are not a substitute for the original COD data sets used in GIS applications. No warranties of any kind are made for any purpose and this dataset is offered as-is.
# Size:
# Format: topojson

