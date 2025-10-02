# Netdata Monitoring

## Objective
Install and run Netdata to visualize system and application performance metrics on CentOS using Docker. This demo shows how to install Docker, run Netdata with persistent storage, monitor host & Docker metrics, capture a dashboard screenshot and push the demo into a GitHub repo for presentation.

## Repository
`netdata`

## Prerequisites
- A CentOS server or VM with root or sudo access
- Docker Engine installed (or Podman as an alternative)
- Git/GitHub account

## Steps
  ### update system & install tools
  dnf update -y
  
  dnf install -y  dnf-plugins-core  git  curl vim

  ### install docker
  dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
  
  dnf install -y  docker-ce  docker-ce-cli  containerd.io  docker-buildx-plugin  docker-compose-plugin
  
  systemctl enable --now docker

  ### prepare directories
  mkdir -p  /etc/netdata  /var/lib/netdata  /var/log/netdata
  
  chown -R 1000:1000  /etc/netdata  /var/lib/netdata  /var/log/netdata

  ### run netdata
    docker run -d --name=netdata \
    
    -p 19999:19999 \
    --cap-add SYS_PTRACE --cap-add SYS_ADMIN \
    -v /etc/netdata:/etc/netdata \
    -v /var/lib/netdata:/var/lib/netdata \
    -v /var/log/netdata:/var/log/netdata \
    -v /etc/passwd:/host/etc/passwd:ro \
    -v /etc/group:/host/etc/group:ro \
    -v /proc:/host/proc:ro \
    -v /sys:/host/sys:ro \
    -v /etc/os-release:/host/etc/os-release:ro \
    -v /var/run/docker.sock:/var/run/docker.sock:ro \
    --restart unless-stopped \
    netdata/netdata:latest

  open: http:/server-ip/:19999
  
  ### What this demo monitors
  
  - CPU, memory, disk IO, load

  - Network interfaces

  - Running Docker containers and container-specific metrics (if docker socket mounted)

  - System logs and Netdata alerts

  ### Firewall / SELinux notes
  Open the Netdata port:

  firewall-cmd --permanent --add-port=19999/tcp
  
  firewall-cmd --reload
  
  If SELinux is enabled and causes permission errors, add :Z to host volume mounts.

  docker-compose (alternative)
  
  docker-compose.yml:

    version: "3.8"
     services:
     netdata:
     image: netdata/netdata:latest
     container_name: netdata
     ports:
        - "19999:19999"
      volumes:
        - /etc/netdata:/etc/netdata
        - /var/lib/netdata:/var/lib/netdata
        - /var/log/netdata:/var/log/netdata
        - /etc/passwd:/host/etc/passwd:ro
        - /etc/group:/host/etc/group:ro
        - /proc:/host/proc:ro
        - /sys:/host/sys:ro
        - /etc/os-release:/host/etc/os-release:ro
        - /var/run/docker.sock:/var/run/docker.sock:ro
      restart: unless-stopped
      cap_add:
        - SYS_PTRACE
        - SYS_ADMIN

  Start with:

  - docker compose up -d
  
  - Capture screenshot
 
  - Open http://server-ip:19999 in a browser.

  Navigate to Overview and Docker/containers charts.

  Take a screenshot and save to screenshots/

## Troubleshooting

  docker: command not found — ensure Docker installed & systemctl start docker.

  Port blocked — check firewalld or cloud security group.

  SELinux: use :Z or adjust contexts.

  If Netdata fails to see Docker containers, ensure /var/run/docker.sock is mounted read-only.

  ## Screenshots

  <img width="1366" height="601" alt="node_dashboard" src="https://github.com/user-attachments/assets/e737e77a-f7f7-4468-914c-ebbabda047cc" />

<img width="1366" height="606" alt="metrics" src="https://github.com/user-attachments/assets/dd02eeed-043a-4ad2-a3cd-1f627c2ff635" />

<img width="1366" height="584" alt="memory" src="https://github.com/user-attachments/assets/556279cc-a64b-4dee-9f17-95433e25c236" />

<img width="1366" height="584" alt="container" src="https://github.com/user-attachments/assets/90c7668f-2335-41ed-8776-ce4254ca994e" />

<img width="1366" height="586" alt="container1" src="https://github.com/user-attachments/assets/d024afda-8370-47c8-a878-0b6b663abd49" />
