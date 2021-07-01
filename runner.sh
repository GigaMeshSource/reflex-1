docker-compose up -d reflex

curl --user assurly:test -d '@query1.json' http://localhost:8888/cep-core/integration/