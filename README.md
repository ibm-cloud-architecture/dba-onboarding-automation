## Onboarding Automation
**an IBM Cloud Pak® for Business Automation use case**

***

**Use Case:** Content and document services

**Use Case Overview:** Focus Corp accelerates the use of unstructured content in an employee onboarding use case using teamspaces and secure external file sharing. You will assume the role of Lucy, an HR employee onboarding specialist at Focus Corp. Lucy’s objective is to improve Focus Corp’s process and ensure various onboarding requirements are met in a secure, structured, consistent and timely manner to onboard the new employees.  Focus Corp must collaborate both internally and externally during the employee onboarding process as well as enforce structured and adhoc workflows. 

**Choose an option:**

  * **Cloud Pak for Business Automation as a Service demo environment (likely an IBMer):** your environment is pre-deployed, continue to the [Getting Started Lab](https://ibm-cloud-architecture.github.io/refarch-dba/use-cases/onboarding-automation/#getting-started-lab).
  * **Install Yourself:** To deploy Onboarding Automation on your own environment, continue reading.

### Environment

We assume the following products are installed, up and running:

* IBM Cloud Pak® for Business Automation version 22.x
    * Automation Foundation on OpenShift
    * Business Automation Applications (including Studio and App Engine) on OpenShift
    * Business Automation Content Services on VMs or OpenShift
    * Business Automation Navigator on OpenShift
    * Business Automation Workflow (BAW) on VMs or OpenShift
        Note: only necessary for the last lab step to launch a process from a document

Note:
1. This setup has not been fully tested on non-SaaS environments - there may be slight differences in the setup.  For example, specify object CONTENT instead of OS1.  
1. It is recommend to clone this GitHub repository rather than individually copying each asset that is required to import into your environment.  

### Deploy the artifacts

1. Determine your credentials
    1. If using Cloud Pak for Business Automation as a Service (CP4BAaaS):
        1. You will use a single login to access CPE, BAS and BAW
        1. Additionally, create the following from `Access Management`
            1. `Service credientials`
                1. Functional ID alias: `OA` (use something short)
                  1. Description: `Used by process app Employee Onboarding - Onboard Employee`
                  1. Role: `Content Platform Engine Role - Class Designer`
                  1. Note: This service account is used by BAW to launch a process from a document.  Additionally, this account is also used to upload sample content using the GraphQL script.
            1. `Users`
                1. Add demo users with access to `Production` environment
                    1. Within the `Production` environment, the user does NOT need any specific roles
            1. `Groups`
                1. Group: **TE_ADMIN**
                    1. Add only administrative users to this group.  
                        1. This access management group identifies users that have access to modify all folders and documents.
                        2. Place the 'OA' service credential into this group
                1. Group: **TE_DEMO**
                    1. Add demo users to this group -OR- add the group `ECMoC_Client_CPE_User`
                        1. This access management group identifies users that can:
                            1. Access content (folders/documents)
                            1. Perform redactions on documents
                            1. Launch the Onboard Employee process app
                1. Group: **TE_OnboardingAutomation_Redaction**
                    1. Add the **TE_DEMO** group to this group
            1. Review the [NextGen User Guide](https://ibm.biz/NextGenUserGuide) for the latest user security required for the Run environment, as of February 2023, it is:
                1. Insights Role: Administrators
                1. Workplace Administrators
                1. Decision Server: Operator
                1. Note: access to the Production environment provides membership into the following access management groups:
                    1. Participants
                    1. ECMoC_Client_CPE_User (from Particpants)
    1. If deploying on your own OpenShift environment:
        * Make sure you have a login to all required components above
    1. If deploying on your own OpenShift environment based on the demo pattern and running on IBM Red Hat OpenShift on IBM Cloud (ROKS):
        * Install the `oc` CLI from the **Client-side requirements** here: [V21.0.x](https://www.ibm.com/docs/en/cloud-paks/cp-biz-automation/21.0.x?topic=deployments-preparing-demo-deployment).  Note: all other **Client-side requirements** are optional for this install but recommended to manage the ROKS cluster.              
1. FileNet Security (Configure in `ACCE`)
    1. `Object Store` (default)
        1. ECMoC_Service_Account - Full Control - This object only
        1. ECMoC_Client_CPE_Administrator - Full Control - This object only  
        1. ECMoC_Client_ACCE_ClassDesigner - Full Control - This object only
        1. ECMoC_Client_ACCE_ApplicationDesigner - Full Control - This object only
        1. baw_dev_administrators - Full Control - This object only
        1. CPE_Bootstrap_User - Full Control - This object only
        1. ECMoC_Client_CPE_User - Use object store - This object only
    1. `Root folder`
        1. Administrators - Full Control - This object and all children
        1. ECMoC_Service_Account - Full Control - This object only
        1. TE_ADMIN - Full Control - This object only
        1. ECMoC_Client_CPE_User - View properties <Default> - This object only
    1. `Folder`: `Focus Corp` (Create manually or use the first step from `Focus Corp folder structure` step below )
        1. Administrators - Full Control - This object and all children
        1. TE_ADMIN - Full Control - This object and all children
        1. TE_DEMO - View properties <Default> - This object and all children
    1. `Default Instance security`
        1. `Folder`
            1. Administrators - Full Control - This object and all children
            1. #CREATOR-OWNER - Full Control - This object only
        1. `Document`
            1. Use default
1. Deploy Content Services
    1. Log into Administration Console for Content Engine (ACCE) and locate your **Object Store** (generally called `OS1` on SaaS and `CONTENT` on ROKS) and perform the following:
        1. `Property Templates` - navigate to **Data Design, Property Templates** and create property templates for:
            1. First Name (String)
            1. Last Name (String)
            1. Application Date (Date Time)
            1. Employee ID (String)
            1. Onboarded (Boolean)
            1. Hire Date (Date Time)
        1. `Document sub-class: Employment Application` - navigate to **Data Design, Classes, Document** and create a Document sub-class named **Employment Application** with these properties:
            1. First Name
            1. Last Name
            1. Application Date
        1. `Folder sub-class: Employee` - navigate to **Data Design, Classes, Folder** and create a Folder sub-class called **Employee** with the following following properties:
            1. First Name
            1. Last Name
            1. Employee ID
            1. Onboarded
            1. Hire Date
    1. Focus Corp folder structure - create folder structure using GraphiQL
        1. Locate your GraphQL URL, using Cloud Pak for Business Automation as a Service **example**, the format is:
            1. https://\<tenant\>.automationcloud.ibm.com/dba/run/content-services-graphql/
        1. Download and review the GitHub script (located within this GitHub): `content-services / graphql / FocusCorp-GraphiQL-Design-YYYY_MM_DD-XX.txt`
        1. The repository id is `OS1` in the script.  If your repository id is different, update the script with your repository id
        1. Copy and paste each section and confirm the script executes successfully on your environment
    1. Sample Content - using the Navigator Browse feature, navigate to folder `\Focus Corp\Human Resources\Onboarded\Employees\Selena Swift` and perform the following:
        1. For Photos - add the images to the `Photos` subfolder from the GitHub source: `content-services / sample-content / Selena Swift / Photos`
        1. For Employee Packet - choose one of the methods below:
            1. Using CURL/GraphQL
                1. Review and execute the GitHub script: `content-services / graphql / FocusCorp-GraphQL-Data-YYYYY_MMDD-XX.txt`
            1. Manual process using Navigator
                1. Download the content from the GitHub source: `content-services / sample-content / Selena Swift / Employee Packet` and manually upload the following:
                    1. Confidentiality Agreement.pdf (Class: Document)
                    1. Employee Manual.docx (Class: Document)
                    1. Focus Corp - Employment Application.pdf (Class: Employment Application)
                        1. First Name: Selena
                        1. Last Name: Swift
                        1. Application Date: specify any date
        1. Optional - TE_DEMO group **Author** permission to folder: `\Focus Corp\Human Resources\Onboarded\Employees\Unsecured`
            1. From Navigator, select the **Unsecured** folder and perform the following:
                1. Update the security permission on the folder:
                    1. Add **Authenicated users** with **Author** permission.  Note: this is selected as an **Alias Account**
                1. Repeat the step above for any subfolders                            
    1. Navigator Administration
        1. Connections, Repositories - the lab uses two object stores - the FileNet content object store and the BAW target object store
            1. For the FileNet content object store, set the following:
                1. **General** tab - Display name: **Corporate Operations**
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
            1. Repository Type=FileNet Content Manager, Viewer=Video Viewer, File Type=video/mp4, video/x-m4v, video/webm, video/quicktime, audio/mpeg, audio/mp4, audio/x-m4a, audio/x-m4b (select all the video/audio formats)
            1. Repository Type=FileNet Content Manager, Viewer=Daeja ViewONE Virtual, File Type=All file types
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
            1. From Navigator Administration, click **Role-based Redactions** and set up the following:
                1. **Reasons** - create/validate that the following reasons exists:  
                    1. Credit Card Number (should already be created)
                    2. Social Security Number (should already be created)
                    3. Name: PII  
                       Description: Personally Identifiable Information
                1. **Policies and Roles**
                    1. Click `Policies and Roles`
                    1. If not connected, connect to your repository: `Corporate Operations`
                    1. **Redaction Roles** - click `New Redaction Role`
                        1. `TE Redaction Editor`
                            1. Name: **TE Redaction Editor**
                            1. Type: **Editor**
                            1. Description: **TE Redaction Editor**
                            1. Membership: click **New Editors**
                                1. Add group: **TE_OnboardingAutomation_Redaction**
                        1. `TE Redaction Viewer`
                            1. Name: **TE Redaction Viewer**
                            1. Type: **Viewer**
                            1. Description: **TE Redaction Viewer**
                            1. Membership: **Editors**
                                1. Add existing editor: **TE_OnboardingAutomation_Redaction**
                    1. **Redaction Policy** - click `New Redaction Policy`
                        1. Name: **TE Redaction Policy**
                        1. Description: **TE Redaction Policy**
                        1. Redaction Reasons: **Credit Card Number, Social Security Number, PII**
                        1. Redaction editors: **TE Redaction Editor**
                        1. Redaction viewers: **TE Redaction Viewer**
    1. Navigator features
        1. Search
            1. Create any type search (ie. Class=Employment Application) with following properties:
                1. **Name** - Employment Application Search
                1. **Description** - Employment Application Search
                1. **Save in** - Corporate Operations / Focus Corp / X Configuration
                1. **Class** - Employment Application
                1. **Share search with** - **Everyone in my company**
        1. Teamspaces
            1.  Create **Employee Onboarding** teamspace template as documented in the Getting Started Lab, section [4.1.1 Teamspace Template Builder](https://ibm-cloud-architecture.github.io/refarch-dba/use-cases/onboarding-automation/#lab-section-411).
                1. Template name: **Employee Onboarding**
                1. Template description: **Teamspace Template for Employee Onboarding**
                1. Share template with**: **Everyone in my company**
1. Deploy BAW artifacts
    1. From the Development environment, select **Build, Studio** (Business Automation Studio) and navigate to **Business automations**
    1. Import Employee_Onboarding - OnboardingAutomation-YYYY.MM.DD_##.twx
    1. Open the Onboarding Automation process app and navigate to Process App Settings -> Servers
        1. Edit the settings for hostname, port, context path, repository, user id, password and so forth for your **Enterprise Content Management Server**
            1. Example values:
                \<tenant\>.automationcloud.ibm.com, 443, /dba/dev/openfncmis_wlp/services11, OS1, \<service id\>, \<service id password\>
            1. Example values:
                fncm-dev-\<tenant\>.blueworkscloud.com, 443, /openfncmis_wlp/services11, OS1, \<service id\>, \<service id password\>
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
    1. From **Studio** (Business Automation Studio), create a new snapshot of the workflow application. Name the snapshot something very shot such as `V2`.  Naming it V2 will allow the launching of the process to be displayed as:
        1. Name: V2
        1. Description: Automation Onboarding
    1. Install the new snapshot to your **Run ProcessServer**
    1. From the Production environment, access **Process Admin Console** and go to **Installed Apps**
        1. Select the **Employee Onboarding** process app
        1. Select **Team Bindings**
            1. Select the group **TE_DEMO** as a member for all the teams (All Users, Managers, Managers of All Users, Process Owner)
        1. Select **Servers**
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
    1. To verify, confirm that the `Onboarding Automation` application is displayed in `Business Automation Apps`

## Contributors
  * Lead content developer [Thomas Yang](https://www.linkedin.com/in/thomasyang44/)
