# gcp_folder_project_iac_module

Terraform IaC to provision a GCP resource hierarchy:

```
Organization
└── v3feed                     (Folder, created once by dv/)
    ├── v3feed-dv               (Folder)
    │   ├── v3feed-dv-data      (Project)
    │   ├── v3feed-dv-k8s       (Project)
    │   └── v3feed-dv-network   (Project)
    ├── v3feed-qa               (Folder)
    │   ├── v3feed-qa-data
    │   ├── v3feed-qa-k8s
    │   └── v3feed-qa-network
    ├── v3feed-ut               (Folder) ... same pattern
    ├── v3feed-pr               (Folder) ... same pattern
    └── v3feed-dr               (Folder) ... same pattern
```

## Structure

| Path         | Purpose                                                             |
|--------------|----------------------------------------------------------------------|
| `modules/folder`  | Reusable module: creates a single `google_folder`               |
| `modules/project` | Reusable module: creates a `google_project` + enables its APIs  |
| `dv/`        | Root module for **dev**. Creates the top-level `v3feed` folder **and** `v3feed-dv` + its 3 projects. |
| `qa/`, `ut/`, `pr/`, `dr/` | Root modules for their respective envs. Each creates `v3feed-<env>` + its 3 projects, reading the `v3feed` parent folder id from `dv`'s remote state (does **not** recreate it). |
| `Pipelines/pipeline.yaml` | Google Cloud Build pipeline: init → validate → plan → (apply/destroy) |

## ⚠️ Apply order matters

`dv` **must be applied first** — it's the only environment that creates the shared `v3feed` parent folder. `qa`, `ut`, `pr`, and `dr` all read `v3feed`'s folder ID out of `dv`'s Terraform state via `terraform_remote_state`, so they will fail to plan until `dv` has been successfully applied at least once.

## Usage (per environment)

```bash
cd dv   # or qa / ut / pr / dr

terraform init \
  -backend-config="bucket=<YOUR_TFSTATE_BUCKET>" \
  -backend-config="prefix=gcp_folder_project_iac_module/dv"

terraform plan \
  -var="org_id=<YOUR_ORG_ID>" \
  -var="billing_account=<YOUR_BILLING_ACCOUNT_ID>"
  # qa/ut/pr/dr also need: -var="dv_state_bucket=<YOUR_TFSTATE_BUCKET>"

terraform apply
```

## Required variables

| Variable          | Where          | Description                                      |
|-------------------|----------------|---------------------------------------------------|
| `org_id`          | all envs       | GCP Organization ID                                |
| `billing_account`  | all envs       | Billing account ID linked to each project          |
| `dv_state_bucket` | qa/ut/pr/dr    | GCS bucket holding `dv`'s Terraform state           |
| `dv_state_prefix` | qa/ut/pr/dr    | GCS prefix holding `dv`'s state (default shown in `variables.tf`) |
| `region`          | all envs       | Default GCP region (default `us-central1`)          |
| `parent_folder_name` | all envs    | Top-level folder display name (default `v3feed`)     |
| `sub_projects`    | all envs       | Map controlling which sub-projects (data/k8s/network) get created and which APIs each enables |

## Customizing sub-projects

Each env's `variables.tf` defines a `sub_projects` map (defaults to `data`, `k8s`, `network`). To add/remove a sub-project or change enabled APIs, edit that map — project IDs are generated automatically as `<parent_folder_name>-<env>-<key>`, e.g. `v3feed-dv-data`.

## CI/CD

`Pipelines/pipeline.yaml` is a Google Cloud Build config. Trigger it per environment:

```bash
gcloud builds submit --config=Pipelines/pipeline.yaml \
  --substitutions=_ENV=dv,_ACTION=plan,_ORG_ID=<org_id>,_BILLING_ACCOUNT=<billing_id>,_TF_STATE_BUCKET=<bucket>
```

Set `_ACTION=apply` to actually apply, or `_ACTION=destroy` to tear down (use with care).

## Prerequisites

- Terraform >= 1.5.0
- `google` provider >= 5.0.0
- A GCS bucket for remote state (create this manually first, it's outside this module's scope)
- Org-level IAM permissions to create folders/projects under the target `org_id` and link `billing_account`
