## Onboarding automation
**an IBM Cloud Pak® for Business Automation use case**

***

**Use Case:** Content and document services

**Use Case Overview:** Focus Corp accelerates the use of unstructured content in an employee onboarding use case using teamspaces and secure external file sharing. You will assume the role of Lucy, an HR employee onboarding specialist at Focus Corp. Lucy’s objective is to improve Focus Corp’s process and ensure various onboarding requirements are met in a secure, structured, consistent and timely manner to onboard the new employees.  Focus Corp must collaborate both internally and externally during the employee onboarding process as well as enforce structured and adhoc workflows. 

**Choose an option:**

  * **Cloud Pak for Business Automation as a Service demo environment (likely an IBMer):** your environment is predeployed, continue to the [Getting Started Lab](https://ibm-cloud-architecture.github.io/refarch-dba/use-cases/onboarding-automation/#getting-started-lab).
  * **Install Yourself:** To deploy Onboarding Automation on your own environment, continue reading.

### Environment

We assume the following products are installed, up and running:

* IBM Cloud Pak® for Business Automation version 21.0.2
    * Automation Foundation on OpenShift
    * Business Automation Applications (including Studio and App Engine) on OpenShift
    * Business Automation Content Services on VMs or OpenShift
    * Business Automation Navigator on OpenShift
    * Business Automation Workflow (BAW) on VMs or OpenShift
        Note: only necessary for the last lab step to launch a process from a document

### Deploy the artifacts

1. Determine your credentials
    1. For Content Services, use your own credentials to login into IBM Content Navigator
    1. For BAW, create a service credential/account
        1. Functional ID alias: OnboardingAutomation
        1. Description: Used by process app Employee Onboarding - Onboard Employee
        1. Role: Content Platform Engine Role - Class Designer
1. Deploy Content Services  (for both DEV and RUN)
    1. Log into Aministration Console for Content Engine (ACCE) and locate your **Object Store** (generally called `OS1`) and perform the following:
        1. Navigate to **Data Design, Property Templates** and create a Property Templates for:
            1. First Name (String)
            1. Last Name (String)
            1. Application Date (Date Time)
            1. Employee ID (String)
            1. Onboarded (Boolean)
            1. Hire Date (Date Time)
        1. Navigate to **Data Design, Classes, Document** and create a Document sub-class called **Employment Application** with the first three properties created in the step above (First Name, Last Name, Application Date)
        1. Navigate to **Data Design, Classes, Folder** and create a Folder sub-class called **Employee** with the following following properties: First Name, Last Name, Employee ID, Onboarded, Hire Date
    1. Using GraphiQL, use the FocusCorp-GraphiQL-YYYY_MMDD_NN.txt script to create the Focus Corp folder structure
        1. The repository id is **OS1** in the script.  If your repository id is different, update the script with your repository id
        1. Copy and paste each section and confirm the script executes successfully on your environment
        1. Review the folder structure for: Focus Corp / Human Resources / Onboarded Employees
            1. Manually recreate the existing folders (Jeff Goodhue, Kathryn Tirador, Lauren Mayes, Selena Swift, Thomas Yang) using the **Employee** folder class.  
                1. Set the First Name, Last Name, Employee ID, Onboarded, and Hire Date properties for each subfolder
                    1. Folder Names: Jeff Goodhue, Kathryn Tirador, Lauren Mayes, Selena Swift, Thomas Yang
                    1. First Name - use the first name based on the folder name
                    1. Last Name - use the last name baed on the folder name
                    1. Employee ID - specify any string value (ie. FC939398)
                    1. Onboarded - set to True
                    1. Hire Date - specify any date
            1. For the Selena Swift folder, create two subfolders called **Employee Packet** and **Photos** and add following content:
                1.  For Employee Packet, add the two documents from the GitHub source: **content-services / sample-content / Selena Swift / Employee Packet**
                    1. Confidentiality Agreement.pdf
                    1. Employee Manual.docx
                1.  For Photos, add the images from the GitHub source: **content-services / sample-content / Selena Swift / Photos**
    1. Navigator Administration
        1. Repositories - the environment uses two object stores - the FileNet content object store and the BAW target object store
            1. For the FileNet content object store:
                1. Ensure that the repository configuration setting for **General, Display Name** is set to **Corporate Operations**
                1. Set **Browse** configuration, **Selected Properties** for:
                        1.  **Show in Details View**: Name, Content Size, Last Modifier, Date Last Modified, Major Version Number, Description
                        1.  **Show in Magazine View**: Name, Last Modifier, Date Last Modified, Likes, Tags, Downloads, Comments
            1. For the BAW target object store, ensure that the repository configuration setting for **General, Display Name** is set to **Workflow Operations**        
        1. Menus
            1. Copy the **Default Document Content Menu** menu option and add options for **Launch Process** and **Share**  (Share is only needed for Additional Assets section)
                1. Update your desktop and update **Context Menus - Content Context Menus** - **Document context menu** to the new menu
            1. Copy the **Default teamspace content list context menu** menu option and add options for **Launch Process** and **Share**
                1. Update your desktop and update **Context Menus - Content Context Menus** - **Teamspace content list context menu** to the new menu
        1. Viewer Maps - ensure that the first two viewers are set:
            1. Repository Type=FileNet Conent Mananger, Viewer=Video Viewer, File Type=video/mp4, video/x-m4v, video/webm, video/quicktime, audio/mpeg, audio/mp4, audio/x-m4a, audio/x-m4b
            1. Repository Type=FileNet Conent Mananger, Viewer=Daeja VidewONE Virtual, File Type=All file types
        1. Desktops - edit your default desktop with the following settings:
            1. **General** tab - **Additional settings** - **When using the Open and Preview actions, display documents in the current window**: checkbox enabled
            1. **Repositories** tab - selected repositories: Workflow Operations, Corporate Operations, and optionally FPOS for Records Management
            1. **Layout** tab
                1. **Displayed features** - Home, Browse, Search, Share, Teamspaces, Entry Template Manager, Work, Work Dashboard, Cases, Reports
                1. **Default feature** - Home
                1. **Additional Desktop Components**
                    1. **Document thumbnails**: set option to **Show**
                    1. **Content list checkboxes**: set option to **Show**
    1. Navigator features
        1. Search
            1. Add a search and name it **Employment Application**
                1. Set Class to Employment Application
        1. Teamspaces
            1.  Create **Employee Onboarding** teamspace template as documented in the Getting Started Lab, section [4.1.1 Teamspace Template Builder](https://ibm-cloud-architecture.github.io/refarch-dba/use-cases/onboarding-automation/#lab-section-411).
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
    1. Import the Onboarding Automation application in Business applications using Onboarding_Automation - App - YYYY.MM.DD_XX.twx
    1. No edit of the application should be required but if an edit is done, create a new snapshot
    1. Export the application as a ZIP
1. Deploy Business Automation Navigator artifacts
    1. Login to Business Automation Navigator's admin desktop
        1. If using Cloud Pak for Business Automation as a Service: Production -> Manage solutions -> Publish
        1. If deploying on your own OpenShift environment: use your Navigator URL with `?desktop=appDesktop1` added to the end and use the menu to go to Administration
    1. Select Connections on the left, edit the Application Engine Connection (generally called `APPENGO`) and connect
        1. If using Cloud Pak for Business Automation as a Service: import the application ZIP file
        1. If deploying on your own OpenShift environment: import the application ZIP file
    1. Edit Details from the application's menu and add appropriate teams to the Permissions table, such as `#AUTHENTICATED-USERS` to make the app available to everyone
    1. Edit the desktop of your choice (generally `appDesktop1`) and on the Layout tab, select the application

## Contributors
  * Lead content developer [Thomas Yang](https://www.linkedin.com/in/thomasyang44/)
