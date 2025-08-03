## Rearc Quest Submission – Kyle Green

### Proof of Completion
Proof of Completion can be found by either opening `proof_of_completion.png` in the root of this repository or by visiting `34.160.189.8` in your browser.

Because this solution uses a self-signed cert, you’ll need to click through your browser’s “unsafe/insecure” warning.

---

### Architectural Decision Record (ADR)

#### UMIG with Load Balancer

Initially, I started with a Cloud Run service, but its implicit load-balanced endpoint didn’t surface the traditional headers needed for this challenge. I therefore switched to a GCE VM in an unmanaged instance group (UMIG) behind a global HTTP(S) Load Balancer for better transparency and easier troubleshooting.  
> *Note:* I’ve retained the Cloud Run Terraform module in this repo for reference; the active solution lives in `terraform/quest_webapp/` (the UMIG module).

#### Modification to `src/`

I moved the application code into its own directory to isolate it from the Terraform configuration. I also modified `src/000.js` to add a `/health` endpoint so the Load Balancer’s health check can pass.

---

### Steps to Reproduce

#### 1. Enable Required APIs  
Ensure the following APIs are enabled:
```
compute.googleapis.com
artifactregistry.googleapis.com
containeranalysis.googleapis.com
run.googleapis.com
logging.googleapis.com
monitoring.googleapis.com
serviceusage.googleapis.com
```

#### 2. Set Up Artifact Registry  
```bash
cd terraform/artifact_registry
terraform init
terraform plan
terraform apply
```

#### 3. Build & Publish the Docker Image  
> *Run this on a machine with Docker (e.g., Google Cloud Shell).*  
```bash
cd ../..  # from terraform/artifact_registry
sh upload_artifact.sh
```

#### 4. Deploy the Webapp as a UMIG  
```bash
cd terraform/quest_webapp  # from repo root
terraform init
terraform plan
terraform apply
```
> **Save** the `lb_ip_address` output for the next step.

#### 5. Deploy the HTTPS Load Balancer  
1. In `terraform/http_lb/generate_cert.sh`, set `LB_IP` to the `lb_ip_address` from the previous step.  
2. Generate the self-signed certificate:
   ```bash
   cd ../http_lb
   sh generate_cert.sh
   ```
3. Deploy:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

#### 6. Verify  
The `quest_webapp_ip_address` output of the `https_lb` module shows the site IP. (e.g. `34.160.189.8` is the current address of the web-app.)  
Because this uses a self-signed cert, you’ll need to click through your browser’s “unsafe/insecure” warning.

---

### Future Improvements (Given more time, I would improve...)

If this proof-of-concept became production, I would:

1. Replace the self-signed cert with a managed certificate from Certificate Manager.  
2. Migrate the UMIG to a Managed Instance Group (MIG) or deploy to GKE for built-in autoscaling. Alternatively, add a Load Balancer in front of Cloud Run via a custom domain.  
3. Automate the entire workflow in a CI/CD pipeline using a service account.
4. Extract the Terraform into reusable modules with environment-specific variables and consume them in a gated CI/CD pipeline. Promote shared patterns into their own repos so multiple services can use them (e.g., web apps). For example, Artifact Registry setup should live separately from the Quest web app repo since it would host multiple repositories.
5. Consolidate `quest_webapp` and `https_lb` modules so they run in one `terraform apply`—avoiding the two-step cert generation workaround.
6. Add a DNS record to point a custom domain to the Load Balancer's IP.
