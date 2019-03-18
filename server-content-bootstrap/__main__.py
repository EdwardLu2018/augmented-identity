from __future__ import print_function
from flask import Flask, render_template, redirect, session, url_for, request, flash
from flask_sqlalchemy import SQLAlchemy
from flask_login import LoginManager, UserMixin, logout_user, login_required, login_user, current_user
from werkzeug.security import generate_password_hash, check_password_hash
import sys, os
basedir = os.path.abspath(os.path.dirname(__file__))

app = Flask(__name__)
app.config['SECRET_KEY'] = "X47XGY52FZHQAFZ5SK60"
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///' + os.path.join(basedir, 'database.db')
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

login_manager = LoginManager()
login_manager.init_app(app)

db = SQLAlchemy(app)

class Users(UserMixin, db.Model):
  	id = db.Column(db.Integer, primary_key=True)
  	fullname = db.Column(db.String(100))
  	andrew_id = db.Column(db.String(50))
  	password_hash = db.Column(db.String(250))
  	completed = db.Column(db.Boolean)
  	major = db.Column(db.String(50))
  	github_username = db.Column(db.String(50))
  	facebook_username = db.Column(db.String(50))
  	linkedin_username = db.Column(db.String(50))
  	personal_website = db.Column(db.String(200))

  	def __init__(self, fullname, andrew_id, password):
  		self.fullname = fullname
  		self.andrew_id = andrew_id
  		self.set_password(password)
  		self.completed = False

  	def set_password(self, password):
  		self.password_hash = generate_password_hash(password)

  	def check_password(self, password):
  		return check_password_hash(self.password_hash, password)

@login_manager.user_loader
def load_user(id):
    return Users.query.get(int(id))

@app.route("/")
def index():
    return render_template("index.html")

@app.route("/register", methods=['GET', 'POST'])
def register():
	if request.method == 'POST':
		first_name = request.form['firstname']
		last_name = request.form['lastname']
		fullname = first_name.strip() + " " + last_name.strip()
		andrew_id = request.form['andrewid']
		password = request.form['password']
		confirmation = request.form['confirmation']

		if not first_name or not last_name or not andrew_id or not password or not confirmation:
			flash("Please enter all fields!", "error")
			return render_template("register.html")

		if check_password_hash(generate_password_hash(password), confirmation):
			new_user = Users(fullname=fullname, andrew_id=andrew_id, password=password)
			print(new_user.password_hash, file=sys.stderr)
			for user in Users.query.all():
				if user.fullname == fullname and user.andrew_id == andrew_id and user.check_password(password):
					login_user(user)
					return redirect(url_for('portfolio'))
			db.session.add(new_user)
			db.session.commit()
			return redirect(url_for('portfolio', andrew_id=andrew_id))
		else:
			flash("Passwords do not match!", "error")
	return render_template("register.html")

@app.route("/login", methods=['GET', 'POST'])
def login():
	if request.method == 'POST':
		andrew_id = request.form['andrewid']
		password = request.form['password']
		if not andrew_id or not password:
			flash("Please enter all fields!", "error")
			return render_template("login.html")
		
		for user in Users.query.all():
			if user.andrew_id == andrew_id and user.check_password(password):
				login_user(user)
				return redirect(url_for('portfolio'))
		
		flash("Information is incorrect. Have you made an account yet?", "error")
	return render_template("login.html")

@app.route("/portfolio", methods=['GET', 'POST'])
@login_required
def portfolio():
	if request.method == 'POST':
		major = request.form["major"]
		github = request.form["github"]
		facebook = request.form["facebook"]
		linkedin = request.form["linkedin"]
		personal = request.form["personal"]

		if not major:
			flash("Please enter your major!", "error")
			return render_template("portfolio.html")
		else:
			current_user.major = major
			current_user.github_username = github
			current_user.facebook_username = facebook
			current_user.linkedin_username = linkedin
			current_user.personal_website = personal
			current_user.completed = True
			flash("Information saved!", "success")
			return render_template("portfolio.html")

		flash("Information is incorrect. Have you made an account yet?", "error")
	return render_template("portfolio.html")

@app.route("/logout")
@login_required
def logout():
    logout_user()
    return redirect(url_for('index'))

@login_manager.unauthorized_handler
def unauthorized():
    return redirect(url_for('login'))

if __name__ == "__main__":
    db.create_all()
    app.run(debug=True) # host="ip address"
