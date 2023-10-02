# Prepare
sudo apt-get update
sudo apt-get install apt-transport-https --yes

# Kubectl Repo
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /usr/share/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/usr/share/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Help Repo
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list

# Install Kubectl & Helm
sudo apt-get update
sudo apt-get install kubectl
sudo apt-get install helm

# Install Java
sudo apt install default-jre

# Install Docker
sudo apt-get install docker.io --yes

# Allow the user "builder" to execute docker command (must be the user used by Jenkins to login)
sudo groupadd docker
sudo usermod -aG docker builder
