#!/usr/bin/env python3
''' 
    Proudly Written by Yosri. G
    https://Yosri.dev
'''
from flask import Flask, request, redirect, abort, jsonify
from flask_pymongo import PyMongo
from fer import FER
from cores.astrology import get_astrology
import matplotlib.pyplot as plt 
import base64
import io


app = Flask(__name__)
app.config['MONGO_URI'] = 'Mongo_DB'
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


@app.route('/ios/post_image', methods=['POST'])
def post_image():
    '''Analayse Picture'''
    if 'BetterMood' not in request.headers['User-Agent']:
        abort(404)
    file = request.form['image'].encode()
    img = base64.decodebytes(file)
    test_image_one = plt.imread(io.BytesIO(img), format='JPG')
    emo_detector = FER(mtcnn=True)
    captured_emotions = emo_detector.detect_emotions(test_image_one)
    if len(captured_emotions) == 0:
        abort(404)
    emotions = captured_emotions[0]['emotions']
    for row in emotions:
        emotions[row] *= 100
        emotions[row] = int(emotions[row])
    return jsonify(emotions)


@app.route('/ios/astrology', methods=['POST'])
def astrology():
    '''Astrology'''
    if 'BetterMood' not in request.headers['User-Agent']:
        abort(404)
    if request.form:
        user_id = request.form.to_dict()
        data = database.users.find_one(user_id)
        if data is None:
            abort(404)
        else:
            astrology_t = get_astrology(data['day'], data['month'], data['year'])
            return jsonify(astrology_t) 
    else:
        abort(404)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port="80")
