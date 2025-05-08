# Kind Cluster Test

This repository helps beginners set up a Kubernetes cluster using Kind and deploy a simple Python service to serve an HTML webpage. Follow the steps below to get started.

## Prerequisites

1. Install Docker: [Docker Installation Guide](https://docs.docker.com/get-docker/)
2. Install Kind: [Kind Installation Guide](https://kind.sigs.k8s.io/docs/user/quick-start/)
3. Install kubectl: [kubectl Installation Guide](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
4. Install Python 3.x: [Python Installation Guide](https://www.python.org/downloads/)

## Prerequisites (Command-Line Installation)

To simplify the setup process, you can install the prerequisites directly from the command line on Linux or macOS:

### 1. Install Docker
```bash
# For Linux
sudo apt update
sudo apt install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker

# For macOS, use Docker Desktop: https://docs.docker.com/docker-for-mac/install/
```

### 2. Install Kind
```bash
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
```

### 3. Install kubectl
```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
```

### 4. Install Python
```bash
# For Linux
sudo apt update
sudo apt install -y python3 python3-pip

# For macOS
brew install python
```

## Steps to Set Up the Environment

### 1. Clone the Repository
```bash
git clone <repository-url>
cd kind-cluster-test
```

### 2. Create a Kind Cluster
Run the following command to create a Kind cluster with the provided configuration:
```bash
kind create cluster --config kind_config.yaml
```

### 3. Apply Kubernetes Resources
Apply the ConfigMap, TLS certificates, secrets, and local volume:
```bash
kubectl apply -f kind_configmap.yaml
kubectl apply -f tls-secret.yaml
kubectl apply -f local-volume.yaml
```

### 4. Deploy the Python Service
Deploy the Python service and expose it:
```bash
kubectl apply -f python-deployment.yaml
kubectl apply -f python-service.yaml
```

### 5. Access the Webpage
Get the service's external IP and port:
```bash
kubectl get svc
```
Open your browser and navigate to `http://<EXTERNAL-IP>:<PORT>` to view the webpage.

## Testing the Python Application Locally

To check if `python-app.py` is a website that you can run and access locally, follow these steps:

### 1. Verify the Python Application

- Open the `python-app.py` file and ensure it contains a Flask application or similar framework serving a webpage.
- Look for a route like `@app.route('/')` that serves content.

### 2. Run the Python Application

- Use the following command to run the application locally:
  ```bash
  python3 python-app.py
  ```
- By default, Flask applications run on `http://127.0.0.1:5000`.

### 3. Access the Website

- Open a web browser and navigate to `http://127.0.0.1:5000`.
- You should see the webpage served by the Python application.

### 4. Check for Errors

- If the application doesn't run, check for missing dependencies. Install them using:
  ```bash
  pip3 install flask
  ```

### 5. Run in Docker (Optional)

- If you want to test it in a containerized environment, ensure the `Dockerfile` is configured to run `python-app.py`.
- Build and run the Docker container:
  ```bash
  docker build -t python-app .
  docker run -p 5000:5000 python-app
  ```
- Access the website at `http://127.0.0.1:5000`.

## Using the Makefile

The `Makefile` in this repository provides several commands to simplify the setup and management of the Kind cluster and the website. Below are the available commands and how to use them:

### Prerequisites
Ensure you have `make` installed on your system. If not, install it using your package manager (e.g., `sudo apt install make` on Ubuntu).

### Available Commands

1. **Run the Website**:
   ```bash
   make run_website
   ```
   This builds the Docker image for the website and runs it on port 80.

2. **Install Kind**:
   ```bash
   make install_kind
   ```
   Installs Kind if it is not already installed.

3. **Install kubectl**:
   ```bash
   make install_kubectl
   ```
   Installs kubectl if it is not already installed.

4. **Create a Kind Cluster Without a Registry**:
   ```bash
   make create_kind_cluster_without_registry
   ```
   Creates a Kind cluster using the configuration in `kind_config.yaml`.

5. **Create a Docker Registry**:
   ```bash
   make create_docker_registry
   ```
   Sets up a local Docker registry.

6. **Connect Registry to Kind Network**:
   ```bash
   make connect_registry_to_kind
   ```
   Connects the local Docker registry to the Kind network and applies the ConfigMap.

7. **Create a Kind Cluster With a Registry**:
   ```bash
   make create_kind_cluster_with_registry
   ```
   Combines the above steps to create a Kind cluster and connect it to the local Docker registry.

8. **Delete the Kind Cluster**:
   ```bash
   make delete_kind_cluster
   ```
   Deletes the Kind cluster and stops the local Docker registry.

### Example Workflow
To set up the environment and run the website:
1. Install Kind and kubectl:
   ```bash
   make install_kind
   make install_kubectl
   ```
2. Create a Kind cluster with a registry:
   ```bash
   make create_kind_cluster_with_registry
   ```
3. Run the website:
   ```bash
   make run_website
   ```
4. Access the website at `http://localhost`.

To clean up:
```bash
make delete_kind_cluster
```

## Cleaning Up
To delete the Kind cluster:
```bash
kind delete cluster
```
