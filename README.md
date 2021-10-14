# term-project-fall-2021-team-2-1
#Method 1: Using python, excel and firebase
Spike protoype for reading the Firebase data and writing the Json object in a excel file as output. 



### Objective
To understand the compatibily between firebase, python and excel. So that it can later used 
in our project by the app user to extract their reseacrh data in a excel file. 

### Finding
1. Using prebuilt panda function only a level json objects can be written in excel, for writing nexted json objects would 
require more data processing before writing to excel. 


### Dependecies 
1. firebase_admin 5.0.3
3. pandas 1.3.3
4. openpyxl 3.0.9

### How to run:
1. Clone the source code 
2. Install all the the dependecies libraries 
  using pip install PACKAGE_NAME==PACKAGE_VERSION
3. Run readFirebaseDB.py
4. Ouput will be generated in output.xlsx

-- python versio used:  Python 3.8.2 

# Method 2: Using google sheets

### Objective
To understand the compatibily between firebase and google sheets. So that it can later used 
in our project by the app user to extract their reseacrh data in a google sheets. 

### Finding
1. Writing data is more complex 
2. Database is less secure as user can alter the script, they can see the database secrect key which will provide user RW access to whole database 

https://docs.google.com/spreadsheets/d/1t-unn2caM-CfEPnHxfis8TJNdZR9RoJC1EIlAbjJAzU/edit#gid=0


### Conclusion:

Using Python, excel and firebase is a better option as it provides better abstraction and security. 
Also, its easier to develop and implement. 
