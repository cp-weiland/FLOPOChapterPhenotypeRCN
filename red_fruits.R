library(SPARQL) # SPARQL querying package

endpoint <- "semantics.senckenberg.de/sparql" # Define the flopo endpoint
 
# create query statement
query <-”
PREFIX FLOPO: <http://purl.obolibrary.org/obo/FLOPO_>
PREFIX RO: <http://purl.obolibrary.org/obo/RO_>
PREFIX gbifvoc: <http://rs.gbif.org/vocabulary/gbif/rank/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX dwc: <http://rs.tdwg.org/dwc/terms/>

SELECT ?species_name ?taxon_uri (STR(?trait_name) AS ?trait_name)
FROM <http://semantics.senckenberg.de/flopo>
WHERE
{
 ?taxon_uri RO:0002200  FLOPO:0001387;
 rdfs:label ?species_name ;
 #  only species, no higher taxa:
 dwc:taxonRank gbifvoc:species .
 FLOPO:0001387 rdfs:label ?trait_name .  
}
LIMIT 5
      “
# Use SPARQL package to submit query and save results to a data frame
qd <- SPARQL(endpoint,query)
df <- t(qd$results)

# write data frame into csv file
write.csv(df, file = "flopo_red_fruit.csv")
