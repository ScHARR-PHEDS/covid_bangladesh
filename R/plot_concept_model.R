# get visualisation using mermaid
plot_concept_model <- function(){
  
# create graph using mermaid
graph <- mermaid(
  "graph LR;
  Triage --> O2+V;
  Triage-->O2;
  O2-->O2+V;
  O2+V-->O2;
  O2-->Dead;
  O2+V-->Dead;
  O2-->Recovered;
  O2+V-->Recovered"
)

return(graph)

}


