# Open Banking Gateway (OBG) Deployment

## Overview
This project provides a reference implementation for deploying the Open Banking Gateway (OBG) project. It includes infrastructure-as-code (Terraform) for AWS, as well as a Docker Compose setup that is used both for local development/testing and as the application stack on EC2 instances in AWS.

The architecture supports secure, scalable, and modular deployment of open banking APIs, fintech UIs, and supporting services.

---

## Architecture
![obg deployment architecture](./docs/obg-deployment-arch.png)

### Application Layer
- **Traefik** as the main reverse proxy and router
- **PostgreSQL** database
- **Open Banking Gateway** (Java Spring Boot)
- **Fintech UI** (Angular/React)
- **Fintech Server** (Java Spring Boot)
- **Consent UI** (Angular/React)
- **HBCI Sandbox Server** (mock banking backend)

---

## Services

| Service                | URL                              | Description                        |
|------------------------|----------------------------------|------------------------------------|
| Open Banking Gateway   | https://obg.obgdeb.com           | Main API gateway                   |
| Fintech UI             | https://fintech-ui.obgdeb.com    | User-facing fintech web app        |
| Fintech Server         | https://fintech-server.obgdeb.com| Backend for fintech UI             |
| Consent UI             | https://consent.obgdeb.com       | Consent management web app         |
| HBCI Sandbox Server    | https://sandbox.obgdeb.com       | Mock banking backend               |

---

## Local Development & AWS Application Stack

### Prerequisites
- [Docker](https://www.docker.com/get-started)
- [Docker Compose](https://docs.docker.com/compose/)
- (Optional) [Terraform](https://www.terraform.io/) and [AWS CLI](https://aws.amazon.com/cli/) for cloud deployment

### Running Locally

1. **Clone the repository:**
   ```bash
   git clone git@github.com:ADORSYS-GIS/obg-deployment.git
   cd obg-deployment
   ```

2. **Start all services:**
   ```bash
   docker-compose up --build
   ```

3. **Access the services:**
    - Open your browser and navigate to:
        - http://obg.obgdeb.com (Open Banking Gateway)
        - http://fintech-ui.obgdeb.com (Fintech UI)
        - http://fintech-server.obgdeb.com (Fintech Server)
        - http://consent.obgdeb.com (Consent UI)
        - http://sandbox.obgdeb.com (HBCI Sandbox)

   > **Note:** You may need to add entries to your `/etc/hosts` file for local domain resolution:
   > ```
   > 127.0.0.1 obg.obgdeb.com fintech-ui.obgdeb.com fintech-server.obgdeb.com consent.obgdeb.com sandbox.obgdeb.com
   > ```
4. **Stop All Services:**
    ```bash
    docker-compose down
    ```

### AWS Deployment (Production)

The same `docker-compose.yml` file is used to orchestrate the application stack on EC2 instances provisioned by Terraform. This ensures consistency between local development and production environments.

For detailed instructions on deploying to AWS, please refer to the [Deployment Guide](terraform/docs/deployment-guide.md).

The guide covers:
- AWS prerequisites and setup
- Infrastructure provisioning with Terraform
- DNS and SSL configuration
- Security best practices
- Troubleshooting and cost estimation

> **Follow the step-by-step process in the deployment guide to ensure a secure and reliable production deployment.**

---

## Docker Compose Services

- **traefik**: Reverse proxy for routing HTTP traffic to services
- **postgres**: Database for all backend services
- **open-banking-gateway**: Main API gateway
- **fintech-ui**: Frontend for fintech users
- **fintech-server**: Backend for fintech UI
- **consent-ui**: Frontend for consent management
- **hbci-sandbox-server**: Mock banking backend

---

## Environment Variables

- See `docker-compose.yml` for all configurable environment variables for each service.
- Database credentials and service URLs are pre-configured for local development and AWS deployment.

---

## Security

- No public IPs are assigned to EC2 instances; all access is via the ALB.
- SSL/TLS is terminated at the ALB using ACM certificates.
- Security groups restrict access to only required ports.

---

## Troubleshooting

- Check logs with `docker-compose logs <service>`
- For AWS issues, see CloudWatch logs and the deployment guide in `terraform/docs/`
- Ensure DNS records are correctly set up for all subdomains

---

**For more details, see the architecture diagrams and the deployment guide in `terraform/docs/`.** 