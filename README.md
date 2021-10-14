# term-project-fall-2021-team-2-1
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
