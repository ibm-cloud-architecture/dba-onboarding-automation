## Automation Onboarding
**an IBM Cloud Pak for Business Automation use case**

***

**Entry Point:** Enable secure, compliant content access with content services

**Use Case Overview:** Focus Corp accelerates the use of unstructured content in an employee onboarding use case using teamspaces and secure external file sharing. You will assume the role of Lucy, an HR employee onboarding specialist at Focus Corp. Lucy’s objective is to improve Focus Corp’s process and ensure various onboarding requirements are met in a secure, structured, consistent and timely manner to onboard the new employees.  Focus Corp must collaborate both internally and externally during the employee onboarding process as well as enforce structured and adhoc workflows. 

**Trial Details:** If you have a Digital Business Automation on Cloud trial, your environment is predeployed, continue to the Guided Tour section within the [Automation Onboarding use case](https://ibm-cloud-architecture.github.io/refarch-dba/use-cases/automation-onboarding/).  Don't have a trial yet? <a href="https://www.ibm.com/account/reg/us-en/signup?formid=urx-45706" target="_blank">Sign up</a> to get started.

**Technical Details:** To deploy Automation Onboarding on your own environment - read on!

### Environment

We assume the following products are installed, up and running:

* IBM Cloud Pak® for Automation version 20.0.3
    * Business Automation Content Services 
    * Business Automation Studio
    * Business Automation Workflow (BAW) on VMs (may work on OpenShift, has not been tested)
        Note: only necessary for the last lab step to launch a process from a document


### Deploy the artifacts

1. Determine your credentials
    1. For Content Services, use your own credentials to login into IBM Content Navigator
    1. For BAW, create a service credential/account 
1. Deploy Content Services artifacts
    1. Login to Aministration Console for Content Engine (ACCE) and create:
        1.  Property Templates for:
            1.  First Name (String)
            1.  Last Name (String)
            1.  Application Date (Date Time)
        1. Document sub-classed called **Employment Application** with the three properties created in the step above
    1. Use the XX GraphiQL script to create the Focus Corp folder structure
    1. Environment uses two object stores - the FileNet content object store and the BAW target object store
        1. For the FileNet content object store, ensure that the repository configuration setting for **Display Name** is set to **Content Operations** 
        1. For the BAW target object store, ensure that the repository configuration setting for **Display Name** is set to **Workflow Operations**
1. Deploy BAW artifacts
    1. Login to Workflow Center and navigate to Process Apps
    1. Import Onboarding_Automation - YYYY.MM.DD_XX.twx 
    1. Open the Onboarding Automation process app and navigate to Process App Settings -> Servers
    1. Edit the settings for hostname, port, context path, repository, authentication and so forth for your Enterprise Content Management server
    1. Use the **Test connection** button to validate connectivity
    1. Go back to Workflow Center and create a new snapshot of the process application
    1. Install the new snapshot to your Workflow Server 
    1. In Process Admin Console, go to Installed Apps, Servers and update the Context Path to the Run environment

## Contributors
  * Lead content developer [Thomas Yang](https://www.linkedin.com/in/thomasyang44/)
