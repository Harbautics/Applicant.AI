#  Applicant.AI.
> Artificial Intelligence that makes finding your next recruit easy.

# Current File Structure
```bash
├── Applicant.AI
│   ├── API
│   │   ├── Applicant.swift
│   │   ├── ApplicantAPIManager.swift
│   │   ├── Application.swift
│   │   ├── Organization.swift
│   │   ├── Posting.swift
│   │   ├── Question.swift
│   │   ├── RecruiterAPIManager.swift
│   │   └── SwiftyJSON.swift
│   ├── AppDelegate.swift
│   ├── Applicant.AI.entitlements
│   ├── Applicant_Controllers
│   │   ├── Applicant_All_Apps_TableViewController.swift
│   │   ├── Applicant_All_Orgs_TableViewController.swift
│   │   ├── Applicant_Specific_Org_TableViewController.swift
│   │   ├── Applicant_Specific_TableViewController.swift
│   │   └── Posting_TableViewController.swift
│   ├── Assets.xcassets
│   │   ├── AppIcon.appiconset
│   │   │   ├── Contents.json
│   │   │   ├── appicon10801080.png
│   │   │   ├── appicon602x.png
│   │   │   └── appicon603x.png
│   │   ├── Contents.json
│   │   ├── appicon.imageset
│   │   │   ├── Contents.json
│   │   │   └── appicon.png
│   │   ├── apps.imageset
│   │   │   ├── Contents.json
│   │   │   └── apps.png
│   │   ├── background.imageset
│   │   │   ├── Contents.json
│   │   │   └── background.png
│   │   ├── brain.imageset
│   │   │   ├── Contents.json
│   │   │   └── brain.png
│   │   ├── business-2.imageset
│   │   │   ├── Contents.json
│   │   │   └── business-2.png
│   │   ├── business.imageset
│   │   │   ├── Contents.json
│   │   │   └── business.png
│   │   ├── first.imageset
│   │   │   ├── Contents.json
│   │   │   └── first.pdf
│   │   ├── gear.imageset
│   │   │   ├── Contents.json
│   │   │   └── noun_Settings_2051977.png
│   │   ├── launch.imageset
│   │   │   ├── Contents.json
│   │   │   └── launch.png
│   │   ├── multiple-users-silhouette.imageset
│   │   │   ├── Contents.json
│   │   │   └── multiple-users-silhouette.png
│   │   ├── org.imageset
│   │   │   ├── Contents.json
│   │   │   └── org.png
│   │   ├── professional.imageset
│   │   │   ├── Contents.json
│   │   │   └── professional.png
│   │   ├── school.imageset
│   │   │   ├── Contents.json
│   │   │   └── education.png
│   │   ├── second.imageset
│   │   │   ├── Contents.json
│   │   │   └── second.pdf
│   │   ├── social.imageset
│   │   │   ├── Contents.json
│   │   │   └── social.png
│   │   └── text-document.imageset
│   │       ├── Contents.json
│   │       └── text-document.png
│   ├── Base.lproj
│   │   ├── LaunchScreen.storyboard
│   │   └── Main.storyboard
│   ├── CELLS
│   │   ├── Description_TableViewCell.swift
│   │   ├── Dropdown_Answer_TableViewCell.swift
│   │   ├── Org_Info_TableViewCell.swift
│   │   ├── Organization_TableViewCell.swift
│   │   ├── Question_Answer_TableViewCell.swift
│   │   ├── Status_TableViewCell.swift
│   │   ├── Submit_TableViewCell.swift
│   │   └── TextAnswer_TableViewCell.swift
│   ├── Globals.swift
│   ├── GoogleService-Info.plist
│   ├── Info.plist
│   ├── Login_ViewController.swift
│   ├── MODEL
│   │   ├── Applications_Provider.swift
│   │   ├── Login_Provider.swift
│   │   ├── Notification_Provider.swift
│   │   └── Organizations_Provider.swift
│   └── Recruiter_Controllers
│       ├── Recruiter_All_Orgs_TableViewController.swift
│       ├── Recruiter_Create_Posting_Questions_TableViewController.swift
│       ├── Recruiter_Postings_TableViewController.swift
│       ├── Recruiter_SpecificOrg_TableViewController.swift
│       └── Recruiter_Specific_Application_TableViewController.swift
├── Applicant.AI.xcodeproj
│   ├── project.pbxproj
│   ├── project.xcworkspace
│   │   ├── contents.xcworkspacedata
│   │   ├── xcshareddata
│   │   │   └── IDEWorkspaceChecks.plist
│   │   └── xcuserdata
│   │       ├── jordanwolff.xcuserdatad
│   │       │   └── UserInterfaceState.xcuserstate
│   │       └── troystacer.xcuserdatad
│   │           └── UserInterfaceState.xcuserstate
│   └── xcuserdata
│       ├── jordanwolff.xcuserdatad
│       │   └── xcschemes
│       │       └── xcschememanagement.plist
│       └── troystacer.xcuserdatad
│           └── xcschemes
│               └── xcschememanagement.plist
├── Applicant.AI.xcworkspace
│   ├── contents.xcworkspacedata
│   ├── xcshareddata
│   │   └── IDEWorkspaceChecks.plist
│   └── xcuserdata
│       └── troystacer.xcuserdatad
│           ├── UserInterfaceState.xcuserstate
│           └── xcdebugger
│               └── Breakpoints_v2.xcbkptlist
├── Applicant.AITests
│   ├── Applicant_AITests.swift
│   └── Info.plist
├── Applicant.AIUITests
│   ├── Applicant_AIUITests.swift
│   └── Info.plist
├── Icons
│   ├── Logo
│   │   ├── lanch.psd
│   │   ├── launch-clear.png
│   │   ├── noun_Artificial\ Intelligence_1903141-2.png
│   │   ├── noun_Artificial\ Intelligence_1903141-3.png
│   │   ├── noun_Artificial\ Intelligence_1903141-4.png
│   │   ├── noun_Artificial\ Intelligence_1903141.png
│   │   └── noun_Artificial\ Intelligence_1903141_000000.png
│   ├── apps.png
│   ├── business-2.png
│   ├── business.png
│   ├── education.png
│   ├── noun_application_204586-2.png
│   ├── noun_application_204586-3.png
│   ├── noun_application_204586-4.png
│   ├── noun_application_204586.png
│   ├── noun_application_204586_000000.png
│   ├── noun_people_1393854-2.png
│   ├── noun_people_1393854-3.png
│   ├── noun_people_1393854-4.png
│   ├── noun_people_1393854.png
│   ├── noun_people_1393854_000000.png
│   ├── org.png
│   ├── professional.png
│   └── social.png
├── OneSignalNotificationServiceExtension
│   ├── Info.plist
│   └── NotificationService.swift
├── Podfile
├── Podfile.lock
├── Pods
  *
└── README.md
```

The folder structure will be the standard for all Xcode project. The assets folder in the Xcode should be used 
for all assets and will be sub divided into different folder based off of type.

# Getting Started 

* Clone the GitHub Repository 
``` 
git clone https://github.com/Harbautics/Applicant.AI.git
```
- navigate the Applicant.AI folder containing the xcode project
- install cocoapods
```
sudo gem install cocoapods
```
- initialize the pod
```
pod install
```
- Open xcode project (using the .xcworkspace file)
- Hit build and run (triangle play button)

Backend has been moved to different repo

# Current Features
- login as applicant or recruiter

Applicant View:
- view all organizations 
  - search using org name or id
- view applications and status for each org
- pick and application, answer questions, and submit application
- view completed applications and statuses

Recruiter View:
- Create organization
- Create Posting (application)
- View/filter applications
- Grant interview/reject/accept applicant
