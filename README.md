## Onboarding automation
**an IBM Cloud Pak® for Business Automation use case**

***

**Use Case:** Content and document services

**Use Case Overview:** Focus Corp accelerates the use of unstructured content in an employee onboarding use case using teamspaces and secure external file sharing. You will assume the role of Lucy, an HR employee onboarding specialist at Focus Corp. Lucy’s objective is to improve Focus Corp’s process and ensure various onboarding requirements are met in a secure, structured, consistent and timely manner to onboard the new employees.  Focus Corp must collaborate both internally and externally during the employee onboarding process as well as enforce structured and adhoc workflows. 

**Choose an option:**

  * **Cloud Pak for Business Automation as a Service demo environment (likely an IBMer):** your environment is pre-deployed, continue to the [Getting Started Lab](https://ibm-cloud-architecture.github.io/refarch-dba/use-cases/onboarding-automation/#getting-started-lab).
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
    1. Create a service credential/account.  
        1. Functional ID alias: `OnboardingAutomation`
        1. Description: `Used by process app Employee Onboarding - Onboard Employee`
        1. Role: `Content Platform Engine Role - Class Designer`
        1. Note: This service account is used by BAW to launch a process from a document.  Additionally, this account is also used to upload sample content using the GraphQL script.
1. Deploy Content Services
    1. Log into Administration Console for Content Engine (ACCE) and locate your **Object Store** (generally called `OS1`) and perform the following:
        1. Navigate to **Data Design, Property Templates** and create property templates for:
            1. First Name (String)
            1. Last Name (String)
            1. Application Date (Date Time)
            1. Employee ID (String)
            1. Onboarded (Boolean)
            1. Hire Date (Date Time)
        1. Navigate to **Data Design, Classes, Document** and create a Document sub-class called **Employment Application** with the first three properties created in the step above (First Name, Last Name, Application Date)
        1. Navigate to **Data Design, Classes, Folder** and create a Folder sub-class called **Employee** with the following following properties: First Name, Last Name, Employee ID, Onboarded, Hire Date
    1. Focus Corp folder structure - using GraphiQL (Cloud Pak for Business Automation as a Service example: https://tenant.automationcloud.ibm.com/dba/dev/content-services-graphql/): use the `dba-onboarding-automation/content-services/FocusCorp-GraphQL-Data-2021_1018_01.txtFocusCorp-GraphiQL-YYYY_MMDD_NN.txt` script to create the Focus Corp folder structure
        1. Download and review and execute the GitHub script: `content-services / graphql / FocusCorp-GraphiQL-Design-YYYY_MM_DD-XX.txt`
        1. The repository id is `OS1` in the script.  If your repository id is different, update the script with your repository id
        1. Copy and paste each section and confirm the script executes successfully on your environment
    1. Sample Content - using the Navigator Browse feature, navigate to folder `\Focus Corp\Human Resources\Onboarded\Employees\Selena Swift` and perform the following:
        1. For Photos, add the images from the GitHub source: `content-services / sample-content / Selena Swift / Photos`
        1. For Employee Packet - choose one of the methods below:
            1. Using CURL/GraphQL
                1. Review and execute the GitHub script: `content-services / graphql / FocusCorp-GraphQL-Data-YYYYY_MMDD-XX.txt`
            1. Manual process using Navigator
                1. Download the images from the GitHub source: `content-services / sample-content / Selena Swift / Employee Packet` and manually upload the following:
                    1. Confidentiality Agreement.pdf (Class: Document)
                    1. Employee Manual.docx (Class: Document)
                    1. Focus Corp - Employment Application.pdf (Class: Employment Application)
                        1. First Name: Selena
                        1. Last Name: Swift
                        1. Application Date: specify any date
        1. Optional - Unsecured folder content
            1. Repeat the last two (Photos and Employee Packet) for folder: `\Focus Corp\Human Resources\Onboarded\Employees\Unsecured`
        1. Optional - TE_DEMO group **Author** permission to folder: `\Focus Corp\Human Resources\Onboarded\Employees\Unsecured`
            1. From Navigator, select the **Unsecured** folder and perform the following:
                  1. Update the security permission on the folder:
                      1. Remove **Authenicated users** from permission **Reader**
                        1. Add **Authenicated users** with **Author** permission.  Note: this is selected as an **Alias Account**                            
    1. Navigator Administration
        1. Repositories - the lab uses two object stores - the FileNet content object store and the BAW target object store
            1. For the FileNet content object store:
                1. **General** tab - Display Name: **Corporate Operations**
                1. **Configuration Parameters** tab:
                    1. **Workflow connection point** - OS1_CP1:1
                    1. **State icons** - enabled for all except **Are uploading** (requires Aspera plugin)
                    1. **Task manager connection ID** - set using an administrator user ID and password to run background tasks that modify the repository.
                    1. **Track downloads** - set to Enable
                    1. **Sync services** - set to Enable
                    1. **Document History** - set to Enable
                    1. **Teamspace management** - set to Enable
                        1. **Enable owners to delete teamspace, included contents** - checked
                    1. **Role-based redactions** - set to Enable
                    1. **Entry template management** - set to Enable
                1. Set **Browse** configuration, **Selected Properties** for:
                    1. **Show in Details View**: Name, Content Size, Last Modifier, Date Last Modified, Major Version Number, Description
                    1. **Show in Magazine View**: Name, Last Modifier, Date Last Modified, Likes, Tags, Downloads, Comments
                    1. Note: if you are unable to specify the fields above, you may need to recreate your repository.  
            1. For the BAW target object store, ensure that the repository configuration setting for **General, Display Name** is set to **Workflow Operations**        
        1. Menus
            1. Copy the **Default document context menu** menu option and add options for **Launch Process** and **Share**  (Share is only needed for Additional Assets section)
                1. Update your desktop and update **Context Menus - Content Context Menus** - **Document context menu** to the new menu
            1. Copy the **Default teamspace content list context menu** menu option and add options for **Launch Process** and **Share**
                1. Update your desktop and update **Context Menus - Content Context Menus** - **Teamspace content list context menu** to the new menu
        1. Viewer Maps - ensure that the first two viewers are set for:
            1. Repository Type=FileNet Conent Mananger, Viewer=Video Viewer, File Type=video/mp4, video/x-m4v, video/webm, video/quicktime, audio/mpeg, audio/mp4, audio/x-m4a, audio/x-m4b (select all the video/audio formats)
            1. Repository Type=FileNet Conent Mananger, Viewer=Daeja VidewONE Virtual, File Type=All file types
            1. Update your desktop and update **Viewer map** setting to use this viewer map
        1. Desktops - edit your default desktop with the following settings:
            1. **General** tab
                1. **Desktop Configuration** section
                    1. **Merge and Split** - set to Enable
                    1. **Sync services** - set to Enable
                    1. **Edit Service** - set to Enable
                    1. **Office for the web service** - set to Enable and Allow collaborative editing
                    1. **Email settings** - Use the HTML-based email service checkbox enabled along with **Allow users to send attachments**
                    1. **Additional settings**
                        1. **Show security settings during add and check in actions** - checkbox disabled
                        1. **Enable this desktop for FileNet P8 workflow email notification** - checkbox enabled
                        1. **When using the Open and Preview actions, display documents in the current window** - checkbox enabled
                    1. **Document History** - set to Enable
            1. **Repositories** tab - selected repositories: Workflow Operations, Corporate Operations, and optionally FPOS for Records Management
            1. **Layout** tab
                1. **Displayed features** - Home, Browse, Search, Share, Teamspaces, Entry Template Manager, Work, Work Dashboard, Cases, Reports
                1. **Default feature** - Home
                1. **Additional Desktop Components**
                    1. **Document thumbnails**: set option to **Show**
                    1. **Status bar**: set option to **Show**
                    1. **Content list checkboxes**: set option to **Show**
        1. Role Based Redaction
            1. Create an **Access Management** group called **TE_DEMO**
                1. Add any users that need access to content in this group
                1. Create an **Access Management** group called **TE_OnboardingAutomation_Redaction**
                    1. Add any users that need to create and view annotations into this group
                    1. Add the **TE_DEMO** group to this group                    
            1. From Navigator Administration, select **Role-based Redactions** and set up the following:
                1. **Reasons** - create/validate that the following reasons exists:  Credit Card Number, Social Security Number, PII (Personally Identifiable Information)
                1. **Policies and Roles**
                    1. **Redaction Roles**
                        1. **Editor** - create an editor redaction role named **TE Redaction Editor** and include group **TE_OnboardingAutomation_Redaction**
                        1. **Viewer** - create an viewer redaction role named **TE Redaction Viewer** and include group **TE_OnboardingAutomation_Redaction** (or simply include the editor role created above)
                    1. **Policy** - create a policy named **TE Redaction Policy** and include the redaction reasons and roles identified above
    1. Navigator features
        1. Search
            1. Create a search with following properties:
                1. **Name** - Employment Application Search
                1. **Description** - Employment Application Search
                1. **Save in** - Corporate Operations / Focus Corp / X Configuration
                1. **Class** - Employment Application
                1. **Share search with** - **Everyone in my company**
        1. Teamspaces
            1.  Create **Employee Onboarding** teamspace template as documented in the Getting Started Lab, section [4.1.1 Teamspace Template Builder](https://ibm-cloud-architecture.github.io/refarch-dba/use-cases/onboarding-automation/#lab-section-411).
                1.  **Share template with** - set to **Everyone in my company**
1. Deploy BAW artifacts
    1. Login to **Workflow Center** and navigate to **Process Apps**
    1. Import Employee_Onboarding - OnboardingAutomation-YYYY.MM.DD_##.twx
    1. Open the Onboarding Automation process app and navigate to Process App Settings -> Servers
        1. Edit the settings for hostname, port, context path, repository, user id, password and so forth for your **Enterprise Content Management Server**
            1.  Example values: demo-emea-03.automationcloud.ibm.com, 443, /dba/dev/openfncmis_wlp/services11, OS1, \<service id\>, \<service id password\>
        1. Use the **Test connection** button to validate connectivity
    1. Confirm settings for process: **Onboard Employee** - **Start**  
        1. General - Event Properties: Type should be set to **Employment Application**
        1. Validate/Edit Data Mapping
            1. Application Date => tw.local.employeeApplicationDate
              1. First Name => tw.local.employeeFirstName
              1. Last Name => tw.local.employeeLastName
              1. Name => tw.local.Name
              1. ID => tw.local.ecmDocID
    1. Save changes and optionally confirm the process app is installed correctly.  
        1. To confirm the process app is installed correctly, create a document with class Employment Application and then right-click on the document to select the **Workflow, Launch Process** menu option.  
            1. From the **Launch Process** dialog, select **Onboard Employee** and confirm the Launch UI dialog is displayed.  
    1. From **Workflow Center** and create a new snapshot of the process application. Name the snapshot something very shot such as `V2`.  Naming it V2 will allow the launching of the process to be displayed as:
        1. Name: Onboard Employee (V2)
        1. Description: Automation Onboarding
    1. Install the new snapshot to your **Run ProcessServer**
    1. From the Production environment, access **Process Admin Console** and go to **Installed Apps, Servers**.  
        1. Select **CONTENT_SERVICES_SERVER** and then update the **Context Path** to the Run environment (ie. /dba/run/openfncmis_wlp/services11)
        1. Use the **Test Connection** button to test the connection.
            1. Click the **Apply** button to save the configuration
1. Deploy Business Automation Studio artifacts
    1. From the Development environment, select **Build, Studio**
    1. From **Business applications**, import the Onboarding Automation application using `Onboarding_Automation - App - YYYY.MM.DD_XX.twx`
    1. No edit of the application should be required but if an edit is done, create a new snapshot
    1. Export the application - select **Export this version to be published (.zip)**
1. Deploy Business Automation Navigator artifacts
    1. Login to Business Automation Navigator's admin desktop
        1. If using Cloud Pak for Business Automation as a Service: Production -> Manage solutions -> Publish -> Business Automation Navigator
        1. If deploying on your own OpenShift environment: use your Navigator URL with `?desktop=appDesktop1` added to the end and use the menu to go to Administration
    1. Select Connections on the left, edit the Application Engine Connection (generally called `APPENGO`) and then select **Connect**
        1. Click the **Applications** tab
        1. If using Cloud Pak for Business Automation as a Service: import the application ZIP file
        1. If deploying on your own OpenShift environment: import the application ZIP file
    1. Edit Details from the application's menu and add appropriate teams to the Permissions table, such as `#AUTHENTICATED-USERS` to make the app available to everyone
    1. Edit the desktop of your choice (generally `appDesktop1`) and on the Layout tab, select the application

## Contributors
  * Lead content developer [Thomas Yang](https://www.linkedin.com/in/thomasyang44/)
