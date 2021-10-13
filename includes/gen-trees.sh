echo "Generating tree diagrams..."

pyang -f tree --tree-line-length 69 ../ietf-list-pagination-nc@*.yang > tree-ietf-list-pagination-nc.txt
