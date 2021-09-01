## Automation Onboarding
**an IBM Cloud Pak for Business Automation use case**

***

**Entry Point:** Enable secure, compliant content access with content services

**Use Case Overview:** Focus Corp accelerates the use of unstructured content in an employee onboarding use case using teamspaces and secure external file sharing. You will assume the role of Lucy, an HR employee onboarding specialist at Focus Corp. Lucy’s objective is to improve Focus Corp’s process and ensure various onboarding requirements are met in a secure, structured, consistent and timely manner to onboard the new employees.  Focus Corp must collaborate both internally and externally during the employee onboarding process as well as enforce structured and adhoc workflows. 

**Trial Details:** If you have a Digital Business Automation on Cloud trial, your environment is predeployed, continue to the Guided Tour section within the [Onboarding Automation use case](https://ibm-cloud-architecture.github.io/refarch-dba/use-cases/onboarding-automation/).  Don't have a trial yet? <a href="https://www.ibm.com/account/reg/us-en/signup?formid=urx-45706" target="_blank">Sign up</a> to get started.

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
      1. Functional ID alias: OnboardingAutomation
      1. Description: Used by process app Employee Onboarding - Onboard Employee
1. Deploy Content Services  (for both DEV and RUN)
    1. Login to Aministration Console for Content Engine (ACCE) and create:
        1. Property Templates for:
            1. First Name (String)
            1. Last Name (String)
            1. Application Date (Date Time)
        1. Document sub-classed called **Employment Application** with the three properties created in the step above
    1. Use the FocusCorp-GraphiQL-YYYY_MMDD_NN.txt script to create the Focus Corp folder structure
    1. Navigator menu options
        1. Copy the **Default Document Content Menu** menu option and add options for **Launch Process** and **Share**  (Share is only needed for Additional Assets section)
            1. Update your desktop and update **Context Menus - Content Context Menus** - **Document context menu** to the new menu
        1. Copy the **Default teamspace content list context menu** menu option and add options for **Launch Process** and **Share**
            1. Update your desktop and update **Context Menus - Content Context Menus** - **Teamspace content list context menu** to the new menu
    1. Add a search and name it **Employment Application**
        1. Set Class to Employment Application
    1. Environment uses two object stores - the FileNet content object store and the BAW target object store
        1. For the FileNet content object store, ensure that the repository configuration setting for
      **Display Name** is set to **Corporate Operations**
        1. For the BAW target object store, ensure that the repository configuration setting for **Display Name** is set to **Workflow Operations**
1. Deploy BAW artifacts
    1. Login to Workflow Center and navigate to Process Apps
    1. Import Employee_Onboarding - OnboardingAutomation-YYYY.MM.DD_##.twx
    1. Open the Onboarding Automation process app and navigate to Process App Settings -> Servers
        1. Edit the settings for hostname, port, context path, repository, authentication and so forth for your Enterprise Content Management server
        1. Use the **Test connection** button to validate connectivity
    1. Confirm settings for the **Onboard Employee** process app - **Start**  
        1. General - Event Properties: Type should be set to **Employment Application**
        1. Validate Data Mapping
        1. Application Date => tw.local.employeeApplicationDate
        1. First Name => tw.local.employeeFirstName
        1. Last Name => tw.local.employeeLastName
        1. Name => tw.local.Name
        1. ID => tw.local.ecmDocID
    1. Go back to Workflow Center and create a new snapshot of the process application
    1. Install the new snapshot to your Workflow Server
    1. In Process Admin Console, go to Installed Apps, Servers and update the Context Path to the Run environment
1. Deploy Business Automation Studio artifacts
    1. If using Cloud Pak for Business Automation as a Service
        1. Create an external automation service named Onboarding_Automation_Application_Services, connect it to the appropriate BAW server, select the Onboard Employee process and publish
        1. Export the external automation service as a ZIP from the Business automations -> External section
    1. If deploying Onboarding Automation on your own OpenShift environment:
        1. Publish the workflow project's snapshot in Business Automation Studio to make the automation services available to applications
    1. Import the Onboarding Automation application in Business applications using Onboarding_Automation - App - YYYY.MM.DD_XX_PLATFORM.twx (where platform is saas-<version> for Cloud Pak for Business Automation as a Service or ocp-demo-<version> for deploying Onboarding Automation on your own OpenShift demo pattern environment)
    1. No edit of the application should be required but if an edit is done, create a new snapshot
    1. Export the application as a ZIP
1. Deploy Business Automation Navigator artifacts
  1. Login to Business Automation Navigator's admin desktop
  1. Open and connect to the Application Engine Connection, sometimes called APPENGO
  1. If using Cloud Pak for Business Automation as a Service: import both the automation service and application ZIP files
  1. If deploying Refund Request on your own OpenShift environment: import only the application ZIP file
  1. Edit the details of the application and add appropriate teams to the Permissions table
  1. Edit the desktop of your choice and on the Layout tab, add the application

## Contributors
  * Lead content developer [Thomas Yang](https://www.linkedin.com/in/thomasyang44/)
