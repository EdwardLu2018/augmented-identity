from __future__ import print_function
from flask import Flask, request, redirect, url_for, render_template, Response, jsonify
from flask_sqlalchemy import SQLAlchemy
import sys, os
from requests import get
from requests.exceptions import RequestException
from contextlib import closing
from webscrape import *
basedir = os.path.abspath(os.path.dirname(__file__))

app = Flask(__name__)
app.config['WTF_CSRF_ENABLED'] = True
app.config['SECRET_KEY'] = 'aug-id'
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///' + os.path.join(basedir, 'database.db')
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

class Student(db.Model):
    id = db.Column('id', db.Integer, primary_key = True)
    userName = db.Column(db.String(50))
    password = db.Column(db.Integer) 

    def __init__(self, name, userName, password):
        self.name = name
        self.userName = userName
        self.password = password
        self.github = ["None", "None", "None"]
        self.linkedIn = "None"
        self.facebook = "None"
        self.personalWebsite = "None"
        self.skills = []
        self.major = "None"
        self.dict = {}
        self.updateDict()
    
    def updateDict(self):
        self.dict = {self.userName: [self.name, self.password, self.github,
                                     self.linkedIn, self.facebook, self.personalWebsite, 
                                     self.skills, self.major]}
    
    def __repr__(self):
        return str(self.password)


CURRENT_USER = Student("none", "none", "none")

@app.route('/')
def index():
    return render_template("registerPageOffish.html")
    
@app.route("/", methods = ["POST", "GET"])
def register():
    fullName = request.form['fullName']
    userName = request.form['user']
    password = request.form['pass']
    confirm = request.form['confirmPass']
    if request.form['button'] == "Register" and fullName != "" and \
                    userName != "" and password != "" and password == confirm:
        new_user = Student(name=fullName, userName=userName, password=password)
        db.session.add(new_user)
        db.session.commit()
        CURRENT_USER = new_user
        print(Student.query.all(), file=sys.stderr)
        return redirect("/finishedRegistration")
    elif request.form['button'] == "Login":
        return redirect("/loginPage")
    else:
        return redirect("/")
    
@app.route('/tasks', methods=['POST', "GET"])
def get_data_from_app():
    data = request.get_json()
    name = str(data["name"])
    for user in Student.query.all():
        if user.name == name:
            return jsonify({user.name: user.dict})
    return jsonify({'':['', '', ["", "",""], '', '', '', ['', '', '', '', ''], ""]})
        
@app.route("/loginPage")
def loginTemplate():
    return render_template("PrettyLoginPage.html")

#login screen, must check if user is in system
@app.route("/loginPage", methods = ["POST", "GET"])
def login():
    for user in Student.query.all():
        if user.userName == request.form['username']:
            if user.password == request.form['password']:
                CURRENT_USER = user
                return redirect("/viewPortfolio")
            else:
                return redirect("/loginPage")
    return redirect("/")
        
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
    if request.method == "POST":
        gitInfo = getDetails(request.form["Github"])
        if gitInfo == None:
            CURRENT_USER.github[0] = "None"
            CURRENT_USER.github[1] = "None"
        else:
            CURRENT_USER.github[0] = gitInfo[0]
            CURRENT_USER.github[1] = gitInfo[1]
        CURRENT_USER.github[2] = request.form["Github"]
        CURRENT_USER.facebook = request.form["Facebook"]
        CURRENT_USER.linkedIn = request.form["LinkedIn"]
        CURRENT_USER.personalWebsite = request.form["PersonalWebsite"]
        CURRENT_USER.skills = request.form["Skills"].split(", ")
        CURRENT_USER.major = request.form["Major"]
        CURRENT_USER.updateDict()
        return render_template("PrettyPortfolioSummary.html", result=tupleList(CURRENT_USER.userName, CURRENT_USER.dict))

def tupleList(user, dict):
    result = []
    if dict[user][2] != None:
        result.append(("Github", dict[user][2][2]))
    else:
        result.append(("Github", "None"))
    result.append(("Facebook", dict[user][3]))
    result.append(("LinkedIn", dict[user][4]))
    result.append(("Personal", dict[user][5]))
    result.append(("Skills", dict[user][6]))
    result.append(("Major", dict[user][7]))
    return result

@app.route("/viewPortfolio", methods=["POST", "GET"])
def showPortfolio():
    return render_template("PrettyPortfolioSummary.html")

@app.route("/viewPortfolio", methods=["POST", "GET"])
def editPortfolioButton():
    return redirect("PrettyPortfolioSummary.html")

if __name__ == '__main__':
    db.create_all()
    app.run(debug=True) # host="ip address"
