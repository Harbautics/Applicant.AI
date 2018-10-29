#  Applicant.AI.
> Artificial Intelligence that makes finding your next recruit easy.

# Current File Structure
```bash
├── Applicant.AI
│   ├── Applicant.AI
│   │   ├── AppDelegate.swift
│   │   ├── Applicant_API
│   │   │   ├── ApplicantAPIManager.swift
│   │   │   ├── Application.swift
│   │   │   ├── Organization.swift
│   │   │   └── SwiftyJSON.swift
│   │   ├── Applicant_Controllers
│   │   │   ├── Applicant_All_Apps_TableViewController.swift
│   │   │   ├── Applicant_All_Orgs_TableViewController.swift
│   │   │   └── Applicant_Specific_TableViewController.swift
│   │   ├── Assets.xcassets
│   │   │   ├── AppIcon.appiconset
│   │   │   │   └── Contents.json
│   │   │   ├── Contents.json
│   │   │   ├── first.imageset
│   │   │   │   ├── Contents.json
│   │   │   │   └── first.pdf
│   │   │   └── second.imageset
│   │   │       ├── Contents.json
│   │   │       └── second.pdf
│   │   ├── Base.lproj
│   │   │   ├── LaunchScreen.storyboard
│   │   │   └── Main.storyboard
│   │   ├── FirstViewController.swift
│   │   ├── Info.plist
│   │   └── SecondViewController.swift
│   ├── Applicant.AI.xcodeproj
│   │   ├── project.pbxproj
│   │   ├── project.xcworkspace
│   │   │   ├── contents.xcworkspacedata
│   │   │   ├── xcshareddata
│   │   │   │   └── IDEWorkspaceChecks.plist
│   │   │   └── xcuserdata
│   │   │       ├── jordanwolff.xcuserdatad
│   │   │       │   └── UserInterfaceState.xcuserstate
│   │   │       └── troystacer.xcuserdatad
│   │   │           ├── IDEFindNavigatorScopes.plist
│   │   │           └── UserInterfaceState.xcuserstate
│   │   └── xcuserdata
│   │       ├── jordanwolff.xcuserdatad
│   │       │   └── xcschemes
│   │       │       └── xcschememanagement.plist
│   │       └── troystacer.xcuserdatad
│   │           └── xcschemes
│   │               └── xcschememanagement.plist
│   ├── Applicant.AITests
│   │   ├── Applicant_AITests.swift
│   │   └── Info.plist
│   └── Applicant.AIUITests
│       ├── Applicant_AIUITests.swift
│       └── Info.plist
└── README.md
```

The folder structure will be the standard for all Xcode project. The assets folder in the Xcode should be used 
for all assets and will be sub divided into different folder based off of type.

# Getting Started 

* Clone the GitHub Repository 
``` 
git clone https://github.com/Harbautics/Applicant.AI.git
```

- Open xcode project (using the .xcodeproj file) 
- Hit build and run (triangle play button)

Backend has been moved to different repo

# Current Features

## Applicant Orgs and Apps View
Applicant tab bar view has been set up. Using placeholder data they can navigate through a list of organizations and view the basic info for an org.
Similarly, they can see a list of applications with placeholder data.
Defined the JSON structure with backend team, more advanced placeholder data coming in few weeks.
