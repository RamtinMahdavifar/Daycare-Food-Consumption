# Plate Waste Recorder

Cross platform application to record plate waste and access nutrition intake in a variety of contexts and settings. Assists in the gathering, maintenance and export of plate waste and nutrition intake data.

## Incremental Deliverable 1:
Documentation and other artifacts related to incremental deliverable 1 can be found [here](https://drive.google.com/drive/folders/1_8bK7QNmn4JO_-fjPdOtxSfsiIA0zo2r?usp=sharing)

## How to Run the App
1. Download [Nox](https://www.bignox.com/en/download/fullPackage) using any browser
2. Run the Nox installer and install Nox

![platewasteinstall1](https://user-images.githubusercontent.com/90283384/135783827-272a5930-33bd-49fb-8327-570391ca5cbe.png)

3. Start Nox

![platewasteinstall2](https://user-images.githubusercontent.com/90283384/135783982-ba43f5d7-d7f9-4546-a1b9-f6e87f75ef11.png)

4. Hyper-v must be disabled to run Nox

![platewasteinstall3](https://user-images.githubusercontent.com/90283384/135784000-b8e158ae-5d54-4f4c-90d4-ea4fb219a9fe.png)

5. Download the latest app APK from the [Build Folder](https://github.com/UniversityOfSaskatchewanCMPT371/term-project-fall-2021-team-2-1/blob/Development/build/app/outputs/flutter-apk/app.apk) 

6. Drag the Downloaded APK over Nox emulator screen (It will automatically install the APK), after the APK is installed, you should see a plate_waste_recorder application logo in the Nox app, click on this to run the app.

![platewasteinstall4](https://user-images.githubusercontent.com/90283384/135784003-86284a9d-4d5c-45e0-a1a2-7d07b5f21417.png)

## App Functionality
As of incremental deliverable 1, the app has the following preliminary functionality:
- The ability to create new institutions/study locations with some basic information (name and address of the institution)

![platewastegif1](https://user-images.githubusercontent.com/90283384/135784030-c592fcda-67db-4165-a23f-8577215ed634.gif)

- Each institution created can be selected at which point information for that institution is displayed along with several other buttons

![platewastegif2](https://user-images.githubusercontent.com/90283384/135784035-0a975e32-4797-4101-916a-014cb6242795.gif)

- Currently each button on an individual institution's page is not implemented and do not open up any other pages or popups. The ability to search through institutions using the search bar in the UI also hasn't be implemented

## Known Issues
As of incremental deliverable 1, the following issues are present in the app: 

- Creating an institution with an empty name or address (or both) will cause the app to crash, this will also overwrite any other institutions currently on the database with an empty string which in turn causes the app to continuously crash upon repeated startup. This is a serious issue that will be address when we add input validation in incremental deliverable 2.

- The database has not been stress tested or built for use offline or in conditions of poor network connectivity as of incremental deliverable 1, using the app in these conditions may cause issues. These issues will be dealt with in future.

## Spike Prototypes
Currently we have created [this](https://github.com/UniversityOfSaskatchewanCMPT371/term-project-fall-2021-team-2-1/releases/tag/Firebase-Flutter_integration) spike prototype for exploring the integration between flutter and the firebase realtime database. In future we plan to develop additional spike prototypes to explore the use of the device camera and associated apis and determine whether google sheets can be used to export data. Depending on stakeholder requirements we may also create a prototype exploring the usage of bluetooth scales as well.



## Flutter Development Starting Resources
Below a beginners guide to flutter is presented as well as several common flutter "recipes" or code snippets:
- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

See the [online flutter documentation](https://flutter.dev/docs) for additional resources




