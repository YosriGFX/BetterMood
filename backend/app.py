#!/usr/bin/env python3
''' 
    Proudly Written by Yosri. G
    https://Yosri.dev
'''
from flask import Flask, request, redirect, abort, jsonify
from flask_pymongo import PyMongo


app = Flask(__name__)
mongo = PyMongo(app)
database = mongo.db
welcome = redirect('https://yosri.dev')



@app.route('/', methods=['GET'])
def index():
    '''index'''
    return welcome


@app.route('/ios/register', methods=['POST'])
def register():
    '''Sign up'''
    if 'BetterMood' not in request.headers['User-Agent']:
        abort(404)
    print(request.headers['User-Agent'])
    required_data = ["user_id", "fname", "lname", "day", "month", "year", "email"]
    if request.form:
        data = request.form.to_dict()
        if set(required_data).issubset(data.keys()):
            if database.users.find_one({'user_id': data['user_id']}) is None:
                database.users.insert_one(data)
                return "success"
            else:
                abort(404)
        else:
            abort(404)
    else:
        abort(404)


@app.route('/ios/login', methods=['POST'])
def login():
    '''Sign up'''
    if 'BetterMood' not in request.headers['User-Agent']:
        abort(404)
    print(request.headers['User-Agent'])
    if request.form:
        user_id = request.form.to_dict()
        data = database.users.find_one(user_id)
        if data is None:
            abort(404)
        else:
            return jsonify({
                'fname': data['fname'],
                'lname': data['lname']
            }) 
    else:
        abort(404)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port="80")
