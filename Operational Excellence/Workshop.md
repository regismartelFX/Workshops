# **Operational Excellence**

## Global

Presentation duration: 120 min.

Topics:

- Resiliency & High-Availability (17 min.)
- Backup (17 min.)
- Disaster Recovery (17 min.)
- Infrastructure Monitoring/Logging (17 min.)
- Application Monitoring/Logging (17 min.)
- Patch Management (17 min.)
- Inventory Management (17 min.)

For each topic:

- High-level explanation resting on M$ documentation (browse [https://docs.microsoft.com/](https://docs.microsoft.com/) instead of Powerpoint slides)
- Demonstrate suggested best practice in Azure (🖥️)
- Known issues and limitations (🚩)
- Questions from audience

## Resiliency & High-Availability

## Backup

On-premises:

- [https://docs.microsoft.com/en-us/azure/backup/backup-mabs-protection-matrix](https://docs.microsoft.com/en-us/azure/backup/backup-mabs-protection-matrix)

IaaS:

- VM (disks):
  - [https://docs.microsoft.com/en-us/azure/backup/backup-azure-vms-introduction](https://docs.microsoft.com/en-us/azure/backup/backup-azure-vms-introduction)
  - 🖥️ Recovery Services Vault
    - Restrict access over RSVs by using RBAC (e.g., Azure Backup administrator, contributor, operator roles)
    - Leverage [Azure Backup Instant Restore capability](https://docs.microsoft.com/en-us/azure/backup/backup-instant-restore-capability), which uses snapshots of the VMs
    - 🚩 [Tradeoffs between lower costs and higher availability](https://docs.microsoft.com/en-ca/azure/storage/common/storage-redundancy).
    - 🚩 One per subscription, per Azure region.
    - Allows for [Cross Region Restore](https://docs.microsoft.com/en-us/azure/backup/backup-create-rs-vault#set-cross-region-restore)
    - [14 days built-in soft-delete feature is enabled by default for all the Recovery Services vaults](https://docs.microsoft.com/en-us/azure/backup/backup-azure-security-feature-cloud#soft-delete).
    - By default, the [data in the Recovery Services vault is encrypted](https://docs.microsoft.com/en-us/azure/backup/backup-azure-recovery-services-vault-overview#encryption-of-backup-data-using-platform-managed-keys) using Microsoft managed keys.
  - 🖥️ Manage VM backups with Azure policies
    - Backup policies ≠ Azure policies for backup.
    - 🚩 Azure policies for backup are not compatible with Lift & Shifted VMs (filters).
  - 🚩 Impossible to restore individual files without restoring the full disk. Use with caution with file servers.
- SQL:
  - [https://docs.microsoft.com/en-us/azure/backup/backup-azure-sql-database](https://docs.microsoft.com/en-us/azure/backup/backup-azure-sql-database)
  - Replaces the SQL-Agent managed backups and saves the disk space.
  - Centralize management through [Backup center](https://docs.microsoft.com/en-us/azure/backup/backup-center-overview).
  - Also available for other database management system (DBMS):
    - SAP HANA
    - PostgreSQL

PaaS / SaaS:

  - 🖥️ Storage account have Data Protection
  - 🖥️ [Backup vault](https://docs.microsoft.com/en-us/azure/backup/backup-vault-overview)
    - Azure Disks (Provides agentless snapshots backup for OS or data disk regardless of whether they are currently attached to a running VM.)
    - Azure Blobs (Azure Storage)
        - Ex. Terraform state files
    - Azure Database for PostgreSQL servers
  - Services that rely on other services for storage (Ex. Function App code is stored is a Storage account) rely on these other services for backup.
  - Other PaaS (Ex. SQL Managed instances) and SaaS (Ex. Exchange Online) have indivudal data protaction capabilities.

## Disaster Recovery

## Infrastructure Monitoring/Logging

## Application Monitoring/Logging

## Patch Management

## Inventory Management