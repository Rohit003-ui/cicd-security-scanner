# Cloud-Based CI/CD Security Scanner

An automated DevSecOps pipeline that scans Terraform Infrastructure-as-Code (IaC) for security misconfigurations **before deployment**, using [Checkov](https://www.checkov.io/) and GitHub Actions.

## What This Project Does

Instead of manually reviewing cloud infrastructure code for security mistakes, this pipeline automatically:
1. Scans Terraform files on every push and pull request
2. Detects common misconfigurations (public S3 buckets, missing encryption, no versioning, etc.)
3. **Blocks the pipeline** if serious issues are found — stopping insecure infrastructure before it ever reaches the cloud

This mirrors real-world DevSecOps practices used to prevent security incidents caused by misconfigured cloud resources — one of the leading causes of cloud data breaches.

## How It Works

Developer pushes Terraform code
│
▼
GitHub Actions triggers automatically
│
▼
Checkov scans the code for misconfigurations
│
┌─────┴─────┐
▼ ▼
Issues found No issues
Pipeline FAILS ❌ Pipeline PASSES ✅


## Before vs After Example

This repo includes a real before/after comparison to demonstrate the scanner in action:

| | `vulnerable-examples/s3-bucket.tf` | `fixed-examples/s3-bucket-secure.tf` |
|---|---|---|
| Public access blocked | ❌ No | ✅ Yes |
| Encryption at rest | ❌ No | ✅ Yes (KMS) |
| Versioning | ❌ No | ✅ Yes |
| Access logging | ❌ No | ✅ Yes |
| Lifecycle policy | ❌ No | ✅ Yes |
| Cross-region replication | ❌ No | ✅ Yes |
| **Checkov result** | **11 failed checks** ❌ | **0 failed checks** ✅ |
| **Pipeline status** | **Blocked** | **Passed** |

## Tech Stack

- **Terraform** — Infrastructure as Code
- **Checkov** — static analysis security scanner for IaC
- **GitHub Actions** — CI/CD automation
- **AWS** — target cloud provider (S3 examples)

## Project Structure

cicd-security-scanner/
├── .github/
│ └── workflows/
│ └── security-scan.yml # GitHub Actions pipeline definition
├── terraform/
│ ├── vulnerable-examples/
│ │ └── s3-bucket.tf # Intentionally insecure (for demo)
│ └── fixed-examples/
│ └── s3-bucket-secure.tf # Fully secured, passes all checks
└── README.md




## Running the Scanner Locally

```bash
pip install checkov
checkov -f terraform/fixed-examples/s3-bucket-secure.tf
```

## Pipeline Screenshots

*(screenshots below show the pipeline blocking insecure code, and passing secure code)*

<!-- Add your screenshots here after uploading them to the repo -->

## What This Demonstrates

- Understanding of Infrastructure-as-Code security risks
- Practical DevSecOps pipeline design ("shift-left" security)
- CI/CD automation with GitHub Actions
- Hands-on experience with a real, widely-used security scanning tool (Checkov)

## Future Improvements

- Add more resource types (EC2 security groups, IAM policies)
- Post scan results as automatic PR comments
- Add a simple dashboard summarizing scan history