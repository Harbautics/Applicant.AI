from flask import Flask, request, send_file
from flask_restful import Resource, Api
import sys
from docx import Document
import subprocess
import re
import os
import shutil

application = app = Flask(__name__)
api = Api(app)

class returnedGroupInformation:
	def __init__(self, groupName, numberOfMembers):
    self.groupName = groupName
    self.numberOfMembers = numberOfMembers

@app.route('/getGroupInformation', methods=['POST'])
def my_form_post():
	groupId = request.args.get('groupId')
	groupData = database.get(groupId)
	#Convert the returned data to a presentable returnable object 
	#so the user can use the returned information
	returnedGroupInformation ret = createRet(groupData)
	return ret

if __name__ == '__main__':
	app.run(debug=True)
