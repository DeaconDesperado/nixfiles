gqlfml() {
  target=${1:-.}
  jq -n --arg query "$(cat $target)" '{query :$query}'
}

gqlpage() {
  target=${1:-.}
  gqlfml $target |  http 'https://bandmanager-graphql-api.spotify.net/graphql'  Authorization:"Bearer $(gcloud auth print-identity-token)" 'Content-type: application/json' 
}
