from __future__ import print_function
from flask import Flask, request, redirect, url_for, render_template, Response, jsonify
import sys

app = Flask(__name__)

##user data
userDict = {'elu2':['Edward Lu', 'edward', ["LiveThesaurus: god-tier thesaurus", "https://github.com/EdwardLu2018/augmented-identity"], 'https://www.facebook.com/', 'https://www.linkedin.com/', 'https://www.pornhub.com/', ['Python', 'Handome', 'Cute', 'JavaScript', 'Excessively Intelligent']]}
personalWebsite = "None"
github = {}
linkedIn = "None"
facebook = "None"
skills = "None"

##Web pages
#initial render
@app.route('/')
def index():
    return render_template ("registerPageOffish.html")
    
# when POST method is called from register page
@app.route("/", methods = ["POST", "GET"])
def register():
    fullName = request.form ['fullName']
    userName = request.form ['user']
    password = request.form ['pass']
    confirm = request.form ['confirmPass']
    if request.form ['button'] == "Register" and fullName != "" and userName != "" and password != "" and password == confirm:
        userDict [userName] = password
        return redirect("/finishedRegistration")
    elif request.form ['button'] == "Or Login":
        return redirect("/loginPage")
    else:
        return redirect ("/")
        
@app.route("/loginPage")
def loginTemplate():
    return render_template("PrettyLoginPage.html")

#login screen, must check if user is in system
@app.route("/loginPage", methods = ["POST", "GET"])
def login():
    username = request.form ['username']
    password = request.form ['password']
    if username not in userDict:
        return redirect("/")
    elif username in userDict and userDict[username][0] != password:
        return redirect("/loginPage")
    else:
        return redirect("/viewData")
        
#redirects the registration page to the finished registration page
@app.route("/finishedRegistration")
def finishedRegistration():
    return render_template("finishedRegistration.html")

#redirects the finished registration page to the enter portfolio screen
@app.route("/finishedRegistration", methods = ["POST", "GET"])
def Continue():
    return redirect("/enterPortfolioScreen")
    
#loads the enter portfolio template
@app.route("/enterPortfolioScreen")
def enterDataScreen():
    return render_template("PrettyPortfolioInformation.html")

#retrieves the linkes and stores it with users
@app.route("/enterPortfolioScreen", methods = ["POST", "GET"])
def enterPortfolioData():
    global personalWebsite
    global github
    #global linkedIn
    global facebook
    global skills
    if request.method == "POST":
        personalWebsiteLink = request.form ["PersonalWebsite"]
        githubLink = request.form ["Github"]
        linkedInLink = request.form ["LinkedIn"]
        facebookLink = request.form ["Facebook"]
        skillsList = request.form ["Skills"]
        if personalWebsiteLink != "enter URL" and personalWebsiteLink != "":
            personalWebsite = personalWebsiteLink
        if githubLink != "enter URL" and githubLink != "":
            github = githubLink
        if linkedInLink != "enter URL" and linkedInLink != "":
            linkedIn = linkedInLink
        if facebookLink != "enter URL" and facebookLink != "":
            facebook = facebookLink
        if skillsList != "enter your skills" and skillsList != "":
            skills = skillsList
        print([personalWebsite, github, linkedIn, facebook, skills], file=sys.stderr)
        return redirect(url_for("viewData", linkedIn = linkedIn))
    if request.method == "GET":
        git = request.args.get('LinkedIn')
        return redirect (url_for ("viewData", linkedIn = linkedIn))


@app.route("/viewData/<linkedIn>")
def viewData(linkedIn):
    return linkedIn
    
# 
# @app.route("/viewData", methods=["POST", "GET"])
# def placeDataInTable ():
#     ## i dont think we actually need frikin global variables i think it is all stored on the server somehow...
#     if reques.method == "POST":
#          return redirect("/enterPortfolioScreen")
#     if request.method = "GET":
#         git = request.args.get('Github')
#         return (redirect (url_for('')
#     print (request.get_json())
#     return jsonify ({request.get_json()})
#     


if __name__ == '__main__':
    app.run(debug=True, host='128.237.173.66')