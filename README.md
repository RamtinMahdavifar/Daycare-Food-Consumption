# Plate Waste Recorder

Cross platform application to record plate waste and access nutrition intake in a variety of contexts and settings. Assists in the gathering, maintenance and export of plate waste and nutrition intake data.

## Incremental Deliverable 4:
Documentation and other artifacts related to incremental deliverable 4 can be found on our [wiki](https://github.com/UniversityOfSaskatchewanCMPT371/term-project-fall-2021-team-2-1/wiki/ID4), additional documents can be found on our google drive [here](https://drive.google.com/drive/folders/1GL7VMHyOubgjZKnWmu_06rsm3HQs3fQr?usp=sharing)

## How to Run the App
1. Download [Nox](https://www.bignox.com/en/download/fullPackage) using any browser
2. Run the Nox installer and install Nox

![platewasteinstall1](https://user-images.githubusercontent.com/90283384/135783827-272a5930-33bd-49fb-8327-570391ca5cbe.png)

3. Start Nox

![platewasteinstall2](https://user-images.githubusercontent.com/90283384/135783982-ba43f5d7-d7f9-4546-a1b9-f6e87f75ef11.png)

4. Hyper-v must be disabled to run Nox

![platewasteinstall3](https://user-images.githubusercontent.com/90283384/135784000-b8e158ae-5d54-4f4c-90d4-ea4fb219a9fe.png)

5. Download the latest app APK from the [Build Pipeline](https://github.com/UniversityOfSaskatchewanCMPT371/term-project-fall-2021-team-2-1/actions/runs/1488232268) towards the bottom of the linked page, unzip the downloaded apk artifact and use the file app.apk as the apk to run the app.

6. Drag the Downloaded app.apk file over Nox emulator screen (It will automatically install the APK), after the APK is installed, you should see a plate_waste_recorder application logo in the Nox app, click on this to run the app.

![platewasteinstall4](https://user-images.githubusercontent.com/90283384/135784003-86284a9d-4d5c-45e0-a1a2-7d07b5f21417.png)

## How to View Test Coverage Results
1. Download the coverage_results artifact from our build pipeline [here](https://github.com/UniversityOfSaskatchewanCMPT371/term-project-fall-2021-team-2-1/actions/runs/1488232268) found at the bottom of the page linked.
2. Unzip the coverage_results directory
3. Open the file index.html in the resulting unzipped directory, this html file will display top level coverage for each code containing directory we have. Clicking on any of the links in the html file will take you to another page showing more specific coverage results. For example from index.html, clicking on the Model link will take you to a new html page showing the coverage of all code in our Model directory where all back-end code is stored:
![tempsnip1](https://user-images.githubusercontent.com/90283384/139604829-85754a0e-f9c4-48fd-8b89-4baf0666366d.png)

![image](https://user-images.githubusercontent.com/90283384/139604860-c40a06e5-9fb1-4ccf-afcb-54ab7c8b46dd.png)
From here you can click on individual file names to see which lines of code are covered. If a line of code is highlighted blue, it has been covered by a test, if a line has been highlighted red it has not been covered:

![image](https://user-images.githubusercontent.com/90283384/139604898-ed480480-7117-4c13-97a7-82d19ae98796.png)

You can also use the links at the top left of the page to navigate back to the top level view and so on.



## App Functionality
As of incremental deliverable 4, the app has the following preliminary functionality:
- The ability to login/create an account to access the app via Google authentication, users can create new institutions/study locations with some basic information (name, address and number of research subjects for the institution), the roster of students/research subjects for an institution can be viewed from within each institution. Users have the option of inputting meal data, there are several classes of meal data that can be input, uneaten meals that have just been served and have not yet been eaten, eaten meals that are the leftovers/food waste after a research subject has been served and has consumed a meal, and finally containers holding food, for example plates, bowls etc which are used to house the meals themselves. For each article of meal data the user is able to submit a name, photo, comments and weight of the meal. Currently the app also has a placeholder page to display the options that users can use to view data for subjects of an institution. The user is able to specify the subject the meal data corresponds to by either manually entering the id of the target subject or by scanning a QR code tied to that particular subject/individual. Currently the meal submission isn't yet hooked up to our database, the roster page for each institution currently reads placeholder data and data is not yet saved on google drive. 

- Login using Google authentication: 

![googleauth](https://user-images.githubusercontent.com/90283384/142796577-1dea65d8-7d56-41e5-a60c-ce3c235f1ea6.gif)

- Adding and selecting institutions:

![Newsubjectfield](https://user-images.githubusercontent.com/90283384/139601344-986bceae-459d-416c-8d7f-38e65687b5bf.gif)

- Viewing the roster of subjects for an institution: 

![roster](https://user-images.githubusercontent.com/90283384/142796891-7f2831db-b436-4acb-b2f3-40c517dbd1d4.gif)

- Viewing the options to view data for an institution:

![viewdata](https://user-images.githubusercontent.com/90283384/142796916-9d236fbf-c507-4e55-a9d9-1cbc71185c87.gif)

- Navigation to meal submission page and photo capture: 

![captureimage](https://user-images.githubusercontent.com/90283384/142796665-98888c1e-2cba-4dc2-8e2a-1b478afad7c0.gif)

- Currently several buttons that haven't yet been implemented navigate to placeholder pages, for example clicking to edit subjects on the subject roster takes you to such a placeholder

- Several components of the app also haven't been implemented: the ability to input meal templates ahead of time, and the ability to view meals previously served or enter updated weights and images for a meal after meal consumption haven't yet been added. The institution search functionality from ID1 also hasn't yet been implemented. Although we have a field for specifying the number of subjects for an institution when creating an institution, these subjects currently are not added or stored and read from the database, new subjects cannot yet be added or removed either. The roster page currently displays placeholder subjects and doesn't yet link to pages showing data for each subject, features of exporting data and exporting the QR codes of all subjects haven't yet been added. As well meals can currently be submitted but are not stored on the database and cannot be viewed or editted.

## Fixed Issues
As of the incremental deliverable 4, the following previously identified issues have been resolved: 
- UI issues related to screen orientation have been fixed, in particular the login page now displays properly in horizontal landscape mode
- When there are currently no institutions that have been created or stored whatsoever, the app now displays a message indicating that there are currently no institutions instead of crashing for example:

![image](https://user-images.githubusercontent.com/90283384/142801624-060d91a8-0757-4597-990d-ae24cd20b563.png)


- Loading animations are now displayed when the app is logging in or reading data from the database.
- Creating institutions with addresses that already exist on the database now displays a message informing the user that the new institution cannot be created and that another institution with the same address already exists
- Creating institutions with a blank or empty name or address no longer causes an app crash, instead a new institution is not created and feedback is provided to the user indicating that they must enter a name and address when creating an institution. ie no institutions are created until both a name and address has been entered by the user, for example: 

![inputvalidationnewfield](https://user-images.githubusercontent.com/90283384/139602133-0d50482d-ced5-4e3d-8337-f37159bc93a3.gif)


## Known Issues
As of incremental deliverable 4, the following issues are present in the app: 
- The database has not been stress tested or built for use offline or in conditions of poor network connectivity as of incremental deliverable 4, using the app in these conditions may cause issues. Database settings that can enable storing data offline have been investigated and are planned to be implemented however.
- The app may not display itself nicely on certain screen sizes, the roster page is an example of this, elements of this page can look quite large on smaller screens.
- A number of bugs have been identified through the use of a bug party, informal records of these bugs can be found [here](https://drive.google.com/file/d/1ijpJJqRXTqG1MyOiX2M_5yKUY8tQKecA/view), these bugs include issues pertaining to login failure upon authentication expiry if the user uses the back button to navigate back to the login page, several crashes and failures to store data if excessively large amounts of data are entered, in particular large strings when submitting subject IDs or institution names or addresses, lack of input validation during meal submission and subject ID entry and several UI issues - roster page UI shifting in response to different length subject IDs for example.
- Overall there are an estimated 62 bugs in the system as of incremental deliverable 4.

## Implementation Features
As of incremental deliverable 4, the following features have been added to our implementation/code base itself:
- Multi-level logging is present in the app in both back-end and front-end UI.
- Back-end dart code features assertions and code contracts/specifications describing pre and post-conditions. Assertions and specifications can be found in front-end UI related code albeit to a greatly lesser extent.
- Depending on build mode, the app reads and writes to different locations of the database, this creates a sort of "sandbox" database when the app is ran in debug mode, when running in debug mode (build mode used by default when running in android studio, can also be specified using flutter run --debug) the app conducts database operations using a location that is specific to the current logged in user of the app, this gives the current logged in user their own independent environment to be used for testing or experimental development. When the app is ran in release mode, (if the app is installed and ran from a release apk or ran using flutter run --release) database operations use regular shared location accessible to all users so the changes made by one user can be seen by others and so on. Below is screenshot taken from the firebase web client showcasing this structure, here we see our regular database locations Research Group Data and Research Groups, these nodes occuring at the highest level are written to and read from when in release mode, there are also several user IDs as top level nodes, a user of the app in debug mode writes and reads data from the Research Group Data and Research Groups nodes under their particular user ID thus separating their data and operations from other users.

![Capture](https://user-images.githubusercontent.com/90283384/142801053-2628e207-26bc-4386-8f8a-923728338bd1.PNG)


- Interfaces in particular for Authentication and Database classes and related functionality currently do not exist but are planned for the future time permitting.

## Spike Prototypes
Currently we have created the following spike prototypes to explore various potential integrations and functionality:
1. ID 1- [Firebase-Flutter_integration](https://github.com/UniversityOfSaskatchewanCMPT371/term-project-fall-2021-team-2-1/releases/tag/Firebase-Flutter_integration) this prototype explores the integration between flutter and the firebase realtime database. 

2. ID 2- [Spike_Firebase_DataExport](https://github.com/UniversityOfSaskatchewanCMPT371/term-project-fall-2021-team-2-1/releases/tag/Spike_Firebase_DataExport) this prototype explores the integration between our firebase realtime database, google sheets and python, in particular in determining how database data can be exported into google sheets.


## Flutter Development Starting Resources
Below a beginners guide to flutter is presented as well as several common flutter "recipes" or code snippets:
- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

See the [online flutter documentation](https://flutter.dev/docs) for additional resources




