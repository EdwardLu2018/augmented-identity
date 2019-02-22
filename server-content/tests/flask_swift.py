from __future__ import print_function
from flask import Flask, request, redirect, url_for, render_template, Response, jsonify
import sys

app = Flask(__name__)

##user data
userDict = {'elu2':['Edward Lu', 'edward', ["augmented-identity", "GitHub Application that reads CMU ID and displays networking information"], 'https://www.facebook.com/', 'https://www.linkedin.com/', 'https://www.pornhub.com/', ['Python', 'Handome', 'Cute', 'JavaScript', 'Excessively Intelligent'], "Cum-Sci Major"]}
personalWebsite = "None"
github = {}
linkedIn = "None"
facebook = "None"
skills = "None"

@app.route('/')
def init():
	return "<p>init</p>"

@app.route('/tasks', methods=['POST', "GET"])
def get():
	data = request.get_json()
	name = str(data["name"])
	for username in userDict:
		if userDict[username][0] == name:
			return jsonify(userDict)
	return jsonify({"error": "error"})

if __name__ == '__main__':
    app.run(debug=True, host='128.237.219.51')

#sudo lsof -i:5000