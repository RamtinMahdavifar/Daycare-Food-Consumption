# python dependencies
import firebase_admin
from firebase_admin import credentials
from firebase_admin import db
import json
import pandas as pd




# Fetch the service account key JSON file contents
cred = credentials.Certificate('testproject-4db53-firebase-adminsdk-x6im3-a5da25846c.json')

# Initialize the app with a service account, granting admin privileges

firebase_admin.initialize_app(cred, {
    'databaseURL': 'https://testproject-4db53-default-rtdb.firebaseio.com'
})

#extract the Research group object content object
snapshot = db.reference('/Research Groups/testResearchGroupName/').get()

#iterate over all the key and find the value for
for key,val in snapshot.items():
    if key == '_institutionsMap':
         data = val



#
with open('data.txt', 'w') as outfile:
    json.dump(data, outfile)

df = pd.read_json (r'data.txt')


df.to_excel(r'output.xlsx')