#/bin/bash
curl -X POST -H "Content-Type: application/json" -d '{"name": "XIAOMI", "price": "275.00", "tag": "5g", "pic_ref": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTKBmH_aC5CmItXprFLTRKpev6HLiUesYoPIA&usqp=CAU"}' localhost:8080/products/
curl -X POST -H "Content-Type: application/json" -d '{"name": "ZTE", "price": "175.00", "tag": "4g", "pic_ref": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR3wu0GHlwzpPPlh0KgQlMIxkY8h7zs7USPIw&usqp=CAU"}' localhost:8080/products/
curl -X POST -H "Content-Type: application/json" -d '{"name": "OPPO", "price": "255.00", "tag": "5g", "pic_ref": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTO1kvevSM1v2ltBdB9ApnOU6GTYsVxT9jYLQ&usqp=CAU"}' localhost:8080/products/
curl -X POST -H "Content-Type: application/json" -d '{"name": "SAMSUNG", "price": "155.00", "tag": "5g", "pic_ref": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRmO3FEddg3lQD1s8f1xdSVselUhHc7ntRvEg&usqp=CAU"}' localhost:8080/products/
