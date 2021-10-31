# Plate Waste Recorder

Cross platform application to record plate waste and access nutrition intake in a variety of contexts and settings. Assists in the gathering, maintenance and export of plate waste and nutrition intake data.

## Incremental Deliverable 3:
Documentation and other artifacts related to incremental deliverable 3 can be found on our [wiki](https://github.com/UniversityOfSaskatchewanCMPT371/term-project-fall-2021-team-2-1/wiki/ID3), additional documents can be found on our google drive [here](https://drive.google.com/drive/folders/1fagtX8sijN0Hs17N98xFa6O1OPY0TXqf?usp=sharing)

## How to Run the App
1. Download [Nox](https://www.bignox.com/en/download/fullPackage) using any browser
2. Run the Nox installer and install Nox

![platewasteinstall1](https://user-images.githubusercontent.com/90283384/135783827-272a5930-33bd-49fb-8327-570391ca5cbe.png)

3. Start Nox

![platewasteinstall2](https://user-images.githubusercontent.com/90283384/135783982-ba43f5d7-d7f9-4546-a1b9-f6e87f75ef11.png)

4. Hyper-v must be disabled to run Nox

![platewasteinstall3](https://user-images.githubusercontent.com/90283384/135784000-b8e158ae-5d54-4f4c-90d4-ea4fb219a9fe.png)

5. Download the latest app APK from the [Build Pipeline](https://github.com/UniversityOfSaskatchewanCMPT371/term-project-fall-2021-team-2-1/actions/runs/1405684354) towards the bottom of the linked page, unzip the downloaded apk artifact and use the file app.apk as the apk to run the app.

6. Drag the Downloaded app.apk file over Nox emulator screen (It will automatically install the APK), after the APK is installed, you should see a plate_waste_recorder application logo in the Nox app, click on this to run the app.

![platewasteinstall4](https://user-images.githubusercontent.com/90283384/135784003-86284a9d-4d5c-45e0-a1a2-7d07b5f21417.png)

## How to View Test Coverage Results
1. Download the coverage_results artifact from our build pipeline [here](https://github.com/UniversityOfSaskatchewanCMPT371/term-project-fall-2021-team-2-1/actions/runs/1405684354) found at the bottom of the page linked.
2. Unzip the coverage_results directory
3. Open the file index.html in the resulting unzipped directory, this html file will display top level coverage for each code containing directory we have. Clicking on any of the links in the html file will take you to another page showing more specific coverage results. For example from index.html, clicking on the Model link will take you to a new html page showing the coverage of all code in our Model directory where all back-end code is stored:
![tempsnip1](https://user-images.githubusercontent.com/90283384/139604829-85754a0e-f9c4-48fd-8b89-4baf0666366d.png)

![image](https://user-images.githubusercontent.com/90283384/139604860-c40a06e5-9fb1-4ccf-afcb-54ab7c8b46dd.png)
From here you can click on individual file names to see which lines of code are covered. If a line of code is highlighted blue, it has been covered by a test, if a line has been highlighted red it has not been covered:

![image](https://user-images.githubusercontent.com/90283384/139604898-ed480480-7117-4c13-97a7-82d19ae98796.png)

You can also use the links at the top left of the page to navigate back to the top level view and so on.



## App Functionality
As of incremental deliverable 3, the app has the following preliminary functionality:
- The ability to create new institutions/study locations with some basic information (name, address and number of research subjects for the institution), the ability to record data including dish name, weight, comments for a dish and an image for a meal. Users can choose to take a picture directly or choose a photo from their device's gallery when adding data for a new dish. A basic login page has also been added although actual back-end authentication functionality hasn't yet been implemented. Currently the meal recording page prompts the user for the type of food being entered, this is a temporary placeholder for allowing the user to select the stage of the meal being recorded, for example if a meal is being created before being consumed, after being consumed or if the plate or container for the meal is being recorded.

- Login and navigation to meal recording page: 

![logingif](https://user-images.githubusercontent.com/90283384/139601195-08a39dc0-f8e8-4898-9cfa-c9322d463169.gif)

- Additional information related to each meal: weight, meal name, comments etc, can be input on this meal creation page: 

![EnterMealFields](https://user-images.githubusercontent.com/90283384/137656511-6e0379b0-38f3-4cbe-b89f-861f2190d28b.gif)

- Pictures of the meal to be added can be either taken directly or added from the device's photo gallery:

![SubmitImage](https://user-images.githubusercontent.com/90283384/137656506-4a833f5c-2992-44ba-b141-1514ae00ab9d.gif)

- Adding and selecting institutions:

![Newsubjectfield](https://user-images.githubusercontent.com/90283384/139601344-986bceae-459d-416c-8d7f-38e65687b5bf.gif)

- Currently each button on an individual institution's page takes you to the meal creation page, these essentially act as stubs so new pages can easily be added corresponding to these buttons when such pages are created. 

- As previously mentioned other buttons for an institution, like for example the Roster button currently takes you to the meal creation page as a sort of stub. The ability to add or select a research subject to assign a new meal to, the ability to input meal templates ahead of time, and the ability to view meals previously served or enter updated weights and images for a meal after meal consumption haven't yet been added. The institution search functionality from ID1 also hasn't yet been implemented, however we have created a sort of prototype expressing this functionality that has yet to be integrated into the app itself. While we have added a field to specify the number of subjects present in an institution, the back-end functionality for actually generating unique identifiers for these subjects and adding these subjects to the database hasn't yet been implemented. The roster page should also display all current subjects and allow editing of subjects, this also has yet to be implemented.

## Fixed Issues
As of the incremental deliverable 3, the following previously identified issues have been resolved: 
- Some UI sizing issues have been addressed, notably, font sizes across the app have been increased to make various fields, buttons and text more readable and make better use of available screen size.
- Creating institutions with a blank or empty name or address no longer causes an app crash, instead a new institution is not created and feedback is provided to the user indicating that they must enter a name and address when creating an institution. ie no institutions are created until both a name and address has been entered by the user, for example: 

![inputvalidationnewfield](https://user-images.githubusercontent.com/90283384/139602133-0d50482d-ced5-4e3d-8337-f37159bc93a3.gif)


## Known Issues
As of incremental deliverable 3, the following issues are present in the app: 
- UI for adding meals needs to be refined, meal pictures currently occupy the entire background of the meal addition page, before adding a meal, there is a small label indicating that no meal has been selected. General UI sizing can also be improved to better make use of the entire screen of a device and generally be more appealing, for example text indicating that no picture has been selected can be replaced with an icon to take a new picture.
- The database has not been stress tested or built for use offline or in conditions of poor network connectivity as of incremental deliverable 1, using the app in these conditions may cause issues. These issues will be dealt with in future.
- The app may not display itself nicely in certain situations in a horizontal or landscape orientation, for example the login page has yet to be generalized to a horizontal orientation and can look warped if in a landscape or horizontal orientation.

## Spike Prototypes
Currently we have created the following spike prototypes to explore various potential integrations and functionality:
1. ID 1- [Firebase-Flutter_integration](https://github.com/UniversityOfSaskatchewanCMPT371/term-project-fall-2021-team-2-1/releases/tag/Firebase-Flutter_integration) this prototype explores the integration between flutter and the firebase realtime database. 

2. ID 2- [Spike_Firebase_DataExport](https://github.com/UniversityOfSaskatchewanCMPT371/term-project-fall-2021-team-2-1/releases/tag/Spike_Firebase_DataExport) this prototype explores the integration between our firebase realtime database, google sheets and python, in particular in determining how database data can be exported into google sheets.


## Flutter Development Starting Resources
Below a beginners guide to flutter is presented as well as several common flutter "recipes" or code snippets:
- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

See the [online flutter documentation](https://flutter.dev/docs) for additional resources




