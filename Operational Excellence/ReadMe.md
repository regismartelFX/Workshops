# **Operational Excellence**

Presentation: [Operational Excellence](https://github.com/regismartelFX/Workshops/wiki/Operational-Excellence)

# **Deployed resources**

The resources needed for the presentation may be deployed using the terraform in this module.  The resources in the presentation topics folders are dependent on those in the "Shared" folder, which need to be deployed in all cases.

They consist in:  
- Shared\Core:  
    - Resource group
    - Automation Account, bound to the Log Analytics workspace  
    - Key vault, including an Access policy for the account used to make the deployment  
    - Log Analytics workspace  
    - Storage account  
    - Virtual network, including one subnet  
- Shared\VM:  
    - Resource groups, 1 per VM  
    - 2 linux VMs  
    - 2 Windows server VMs, deployed in different Availability Zones  
    - 2 Windows workstation VMs  
- Shared\Bastion:  
    - Bastion host, to connect to the virtual machine (provision only when needed to avoid costs)  
- Backup  
    - Recovery Services vault  
    - Backup vault  
    - Policy assignment, to automate VM enrollment  
- Disaster Recovery  
    - Resource group  
    - Recovery Services vault  
    - Storage account  
    - Azure Site Recovery  
    - VM enrollment in ASR  
    - Virtual network, including one subnet  
- Inventory Management  
    - Log Analytics workspace solution "ChangeTracking"  
- Monitoring and Logging  
    - Custom Policies, Initiative and Policy assignments, to automate Diagnostic settings configuration at resource level for most resources  
    - Diagnostic settings configuration, at Subscription level  
    - Policy assignments, to enable Azure Monitor for VMs and VM scale sets  
    - Policy assignments, to enable Traffic analytics and NSG Flow logs  
    - Action group  
    - ResourceHealth and ServiceHealth alerts  
    - Service plan  
    - Web app  
    - Application insights  
- Patch Management  
    - Log Analytics workspace solution "Updates"  
    - Tag-based software update configurations  
- Resiliency and High-Availability  
    - ?  

# **How to use**

There is no CI/CD integration at this point.

The "Info" folder holds a module containing only outputs that can be used to customize the deployment.

1. Fork the repo if you need to make any customizations.  Clone locally.  
2. Create "_override" files for each backend.tf and provider.tf. (https://www.terraform.io/language/files/override)  
3. Deploy "Shared\Core".  
4. **Change the value of the secret "default-vm-password" in the Key vault.**  
5. Deploy "Shared\VM".  
6. Deploy "Shared\Bastion" if you need to customize the VMs, for example to install a SQL Server using DSC in order to demonstrate database backup.  
7. Deploy any or all presentation topics folders.  Consider making your deployments a few days prior to the presentation to have backups, patched VMs, logs, etc. to make demonstrations during the presentation.  
8. **Run Remediation tasks** to ensure policies are being applied to all deployed resources.  This is because some policies are created after the resources onto which they apply.  