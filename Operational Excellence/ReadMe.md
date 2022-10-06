# **Operational Excellence**

Presentation: [Operational Excellence](https://github.com/regismartelFX/Workshops/wiki/Operational-Excellence)

# **Deployed resources**

The resources needed for the presentation may be deployed using the terraform in this module.  The resources in the presentation topics folders are dependent on those in the "Shared" folder, which need to be deployed in all cases.

They consist in:  
- Shared\Core:  
    - Automation Account, bound to the Log Analytics workspace  
    - Key vault  
    - Log Analytics workspace  
    - Storage account  
    - Virtual network, including one subnet  
- Shared\VM:  
    - 2 linux VMs  
    - 2 Windows server VMs  
    - 2 Windows workstation VMs  
- Shared\Bastion:
    - Bastion host, to connect to the virtual machine (provision only when needed to avoid costs)   


# **How to use**

No CI/CD integration at this point.

1. Fork the repo if you need to make any customizations.  
2. Create "_override" files for each backend.tf and provider.tf (https://www.terraform.io/language/files/override)