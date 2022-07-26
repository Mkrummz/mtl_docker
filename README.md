# Zero to Observable in < 30 Min

## Demo Objective

This workshop will walk you through how to collect and visualize metrics, logs and traces from your distributed microservice application.

## Prerequisites
[Sign up for our free Grafana Cloud Account](https://grafana.com/)

[GCP Cloud Account](https://cloud.google.com)

Optional: Download a Text Editor (ex: [Visual Studio Code](https://code.visualstudio.com/download))

## Application Overview
This demo spins up a simplified containerized "web shop" application.

![website](images/shop.png)

The application consists of 5 microservices:
- web-shop: a user interface that allows you to add items to a shopping cart, as well as delete all items in the shopping cart.
- shopping-cart: a backend service that interacts with a MariaDB instance. It persists the shopping cart items of the different users.
- products: a backend service that serves the available products of the web shop.
- mariadb: A mariadb instance to persist products and shopping cart items.
- shopping cart simulator: a service that simulates light user traffic by adding things to the shopping cart via the web-shop API.
- broker: a kafka broker to persist checked out shopping carts before they are reset.

![Alt text](images/arch.png)

#### Architecture Overview
- The web shop UI is a Python Flask service that renders 2 HTML pages: 
    - landing page- loads products by requesting them from the products API
    - shopping cart view- interacts with the shopping cart service to get the current shopping cart items from the user
- The shopping cart service is written in Flask and offers an API to interact with MariaDB
- The products service is written in Java Spring Boot and offers an API to load the currently available shop items from MariaDB
- The products service has a Kafka producer and consumer implemented:
    - The producer- sends the content of the shopping cart as JSON to a Kafka topic
    - The consumer- logs the message

## Part 0: Setup Prior to Workshop
We will be using [Cloud Shell](https://cloud.google.com/shell) to run this workshop. Cloud Shell is a GCP offering and allows you to manage your cloud resources via terminal. As well it comes preloaded with the utilites you will be using today: kubectl, curl, and envsubst

### Setting up your IDE 

You will start off by opening up Cloud Shell. This can take a minute depending on when the last time you used it was.

Once it is open you will run the following commands to pull the repo from GitHub:

***Ctrl + v does not work in cloud shell. You must use Ctrl + Shift + v or right click -> paste
```bash
git clone https://github.com/Mkrummz/mtl_docker.git
cd mtl_docker
```
Set the Env Variables

```bash
#select the geographic deployment location
#https://cloud.google.com/compute/docs/regions-zones (ex: europe-north1-a, us-central1-a)
zone=us-central1-c

#give the cluster a name
clustername=web-shop-app

#define the Container Namespace.
#DO NOT MODIFY unless you also modify web-shop-app.yaml
namespace=web-shop-app

#input your first name (or initals)
owner=mmk

#the date you expect to delete the cluster by
deletedate=07-29-2022
```

### Deploying your Cluster 

Spin up a GKE cluster
```bash
gcloud container clusters create --zone ${zone} ${clustername} --labels owner=${owner},lifetime=${deletedate}
```

Get Cluster Credentials
```bash
gcloud container clusters get-credentials ${clustername} --zone ${zone}
```

Deploy App
```bash
kubectl apply -f web-shop-app.yaml
```

Check to see if all containers are all in the ready state
```bash
kubectl get deployments --all-namespaces
```

If yes, the set up a port-forwarder for the products container
```bash
#get container name, choose one that start with productsXXXX
kubectl get pod -n ${namespace}
```

```bash
#input it in here
#example kubectl port-forward -n ${namespace} products-7cf9db6b6-splt5 8080:8080
kubectl port-forward -n ${namespace} <_pod_name_> 8080:8080
```

While that is running open a new terminal and run the curl commands to populate the store front
```bash
cd mtl_docker
sh ./load_store.sh
```
Now kill the port forwarding process on the other temrinal (control + c) we no longer need that

If control+ c didnt work you can run the following
```bash
jobs
kill %1
jobs
```
if successful you should no longer see any jobs running

Next grab the website URL
```bash
kubectl get -n ${namespace} service web-shop
```
Naviagate to the URL: http://<_hostname or public ip_>:3389/shop?name=User

Congrats you have completed the workshop setup steps!

## Prework Data Source Configuration

name =  ``` traceid ```

regex = ``` .*?trace_*[I|i][d|D]=(\w+).* ```

internal link = tracing

![Alt text](images/logs.png)

We got these values from: line 49 of shopping-cart/wsgi.py and line 48 of web-shop/wsgi.py

![Alt text](images/shopping-cart_logs.png)

### Traces to Logs correlation setup:
Loki can recieve a set of labels along with log line. These labels are used to index log entries and query. By default the Docker driver will add:
- filename: where the log is written to on disk
- host: the hostname where the log has been generated
- swarm_stack, swarm_service: added when deploying from Docker Swarm
- compose_project, compose_service: added when deploying with Docker Compose

#### Data Source Configuration
Data source =  ``` Loki ```

Tags = ```bash service.name ``` = ``` compose_service ```

Toggle on **Map tag names** and **Enable Node Graph**

![Alt text](images/traces.png)

We got these values from: line 29 of shopping-cart/wsgi.py and line 29 of web-shop/wsgi.py

![Alt text](images/shopping-cart_traces.png)

***Do one with prometheus as well with a 15s scrape interval

## Part 1
Follow the Kubernetes Monitoring steps in the Integrations and Connections portion. Do it in an account you arent currently sending k8 data to. If you turn off sending k8 data it will revert back to like you never used it!

## Spin Down the Env
1. Delete the probs you created in Synthetic Monitoring
2. To delete your GKE cluster run:
    ```bash
    gcloud container clusters delete ${clustername} --zone=${zone}
    ```

## Acknowledgements

[Web Shop Observability](https://github.com/Condla/web-shop-o11y-demo) was created by Stefan Dunkler

Adapted from a [workshop](https://docs.google.com/presentation/d/1TWWFg1j-Inu4aoWzY63m9KQAKBzIwOH9hKPTSTol7Qk/edit#slide=id.g135b07445ea_0_142) put together by Raúl Marín 
