# Start/Stop Azure VMs based on tag values
 
![](https://img.shields.io/badge/Category-Compute-lightgrey)
![](https://img.shields.io/badge/Code-PowerShell-blue)
![](https://img.shields.io/badge/Cloud-Azure-blue)
![](https://img.shields.io/badge/Tools-Function_Apps-yellow)
![](https://img.shields.io/badge/Version-1.0.0-orange)
 
This project is meant to start and stop VMs in the Azure environment based on user supplied tag values.
 
## ❓ Description
 
After implementing this project, a user can apply a "Start_Time" and a "Shutdown_Time" tag along with corresponding AM/PM time values, and a function app will turn off or start the VMs when appropriate.
 
## 🎯 Purpose
 
This project is helpful in a development environment where VMs do not need to run 24/7. Another use case is business applications that only are used during business hours and sit idle at all other hours. Since Azure charges for running VMs, regardless of load, this solution can cut down costs.
 
## 🔨 Tools & Technologies 🧰
 
- Azure Resource Group
- Azure Function App
- PowerShell script
 
## 🏗️ Setup ✔️
 
1. Deploy a Resource Group in which the function app will be placed.
2. Within the Resource Group created in step 1, create a function app.
    - You will likely want to use a "Consumption (Serverless)" plan. For more information see [-Function App Plans]("https://docs.microsoft.com/en-us/azure/azure-functions/functions-scale?WT.mc_id=Portal-WebsitesExtension")
 
3. After your function app has been created you need to create a managed identity. 
    - Since the function app will be starting and stopping VMs, give it appropriate permissions.
4. Azure PowerShell modules are not automatically included. 
    - 1. Navigate to Advanced Tools under Development Tools and select Go.
    - 2. Select the debug console dropdown and go to PowerShell.
    - 3. Navigate the folder structure to site\wwwroot\
    - 4. Open "requirements.psd1" and uncomment the indicated line.
    - 5. Open "hosts.json" and make sure managed dependency is enabled.
    - 6. Restart your function app.
 
5. Now we can create a function and add the required code.
    - 1. Under functions select create and use the "Timer trigger".
        - Select at what times you want your function app to check if VMs need to be started or stopped.
            - The times are in CRON format. [Crontab](https://crontab.guru/) may be helpful.
    - 2. Now that our function is created, we need to add the PowerShell script to it.
        - Go to Code + Test and add [StartStopVM.ps1](StartStopVM.ps1)
6. We are now ready to add a "Start_Time" and a "Shutdown_Time" tag to appropriate VMs and provide time values.
