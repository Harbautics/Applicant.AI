#  Applicant.AI.
> Artificial Intelligence that makes finding your next recruit easy.

# Current File Structure
```bash
├── Applicant.AI
│   ├── AppDelegate.swift
│   ├── Applicant_API
│   │   ├── Applicant.swift
│   │   ├── ApplicantAPIManager.swift
│   │   ├── Application.swift
│   │   ├── Organization.swift
│   │   ├── Posting.swift
│   │   ├── Question.swift
│   │   └── SwiftyJSON.swift
│   ├── Applicant_Controllers
│   │   ├── Applicant_All_Apps_TableViewController.swift
│   │   ├── Applicant_All_Orgs_TableViewController.swift
│   │   ├── Applicant_Specific_Org_TableViewController.swift
│   │   ├── Applicant_Specific_TableViewController.swift
│   │   └── Posting_TableViewController.swift
│   ├── Applicant_Model
│   │   ├── Applications_Provider.swift
│   │   └── Organizations_Provider.swift
│   ├── Assets.xcassets
│   │   ├── AppIcon.appiconset
│   │   │   └── Contents.json
│   │   ├── Contents.json
│   │   ├── first.imageset
│   │   │   ├── Contents.json
│   │   │   └── first.pdf
│   │   ├── multiple-users-silhouette.imageset
│   │   │   ├── Contents.json
│   │   │   └── multiple-users-silhouette.png
│   │   ├── second.imageset
│   │   │   ├── Contents.json
│   │   │   └── second.pdf
│   │   └── text-document.imageset
│   │       ├── Contents.json
│   │       └── text-document.png
│   ├── Base.lproj
│   │   ├── LaunchScreen.storyboard
│   │   └── Main.storyboard
│   ├── Custom\ Cells
│   │   ├── Description_TableViewCell.swift
│   │   ├── Dropdown_Answer_TableViewCell.swift
│   │   ├── Status_TableViewCell.swift
│   │   └── TextAnswer_TableViewCell.swift
│   └── Info.plist
├── Applicant.AI.xcodeproj
│   ├── project.pbxproj
│   ├── project.xcworkspace
│   │   ├── contents.xcworkspacedata
│   │   ├── xcshareddata
│   │   │   └── IDEWorkspaceChecks.plist
│   │   └── xcuserdata
│   │       ├── alexisopsasnick.xcuserdatad
│   │       │   └── UserInterfaceState.xcuserstate
│   │       ├── jordanwolff.xcuserdatad
│   │       │   └── UserInterfaceState.xcuserstate
│   │       └── troystacer.xcuserdatad
│   │           └── UserInterfaceState.xcuserstate
│   └── xcuserdata
│       ├── alexisopsasnick.xcuserdatad
│       │   └── xcschemes
│       │       └── xcschememanagement.plist
│       ├── jordanwolff.xcuserdatad
│       │   ├── xcdebugger
│       │   │   └── Breakpoints_v2.xcbkptlist
│       │   └── xcschemes
│       │       └── xcschememanagement.plist
│       └── troystacer.xcuserdatad
│           └── xcschemes
│               └── xcschememanagement.plist
├── Applicant.AITests
│   ├── Applicant_AITests.swift
│   └── Info.plist
├── Applicant.AIUITests
│   ├── Applicant_AIUITests.swift
│   └── Info.plist
└── README.md
```

The folder structure will be the standard for all Xcode project. The assets folder in the Xcode should be used 
for all assets and will be sub divided into different folder based off of type.

# Getting Started 

* Clone the GitHub Repository 
``` git clone https://github.com/Harbautics/Applicant.AI.git```
- navigate the Applicant.AI folder containing the xcode project
- install cocoapods
```sudo gem install cocoapods```
- initialize the pod
```pod install```
- Open xcode project (using the .xcworkspace file)
- Hit build and run (triangle play button)

Backend has been moved to different repo

# Current Features
- login 

Applicant View:
- view all organizations 
  - search using org name or id
- view applications and status for each org
- pick and application, answer questions, and submit application

Recruiter View:
- Create organization

## Applicant Orgs and Apps View
Applicant tab bar view has been set up. Using placeholder data they can navigate through a list of organizations and view the basic info for an org.
Similarly, they can see a list of applications with placeholder data.
Defined the JSON structure with backend team, more advanced placeholder data coming in few weeks.
