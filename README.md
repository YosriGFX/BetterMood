<div align="center">
    <img src="screenshot/logo_text.png" width="200" alt="BetterMood">
</div>

---

# Introduction
> BetterMood is an iOS app that uses Tensorflow to recognize user’s emotions, convert it into categories then send via our api along with the user’s date of birth and name, to end up with a emotion analyse and horoscope prediction.

> All generated information will be based on the user's horoscope sign as I believe in astrology, and the actual user face signs.

# User Experience

## Authentication Page

<div align="center">
    <h3>Login</h3>
    <img src="screenshot/login.png" width="175" alt="BetterMood">
    <img src="screenshot/login_w1.png" width="175" alt="BetterMood">
    <img src="screenshot/login_w2.png" width="175" alt="BetterMood">
    <h3>Reset Password</h3>
    <img src="screenshot/forget.png" width="175" alt="BetterMood">
    <img src="screenshot/forget_w1.png" width="175" alt="BetterMood">
    <h3>Register</h3>
    <img src="screenshot/register.png" width="175" alt="BetterMood">
    <img src="screenshot/register_2.png" width="175" alt="BetterMood">
    <img src="screenshot/register_w1.png" width="175" alt="BetterMood">
</div>

## Home Page

> We provide Emotion recognition that return BarChart Contains:
> Neutral, Happy, Angry, Sad, Surprise, Fear, Disgust
> Also Daily horoscope based on daily prediction, contains:
> Today's, Romance, Money, Career, Travel, Home

<div align="center">
    <h3>Parrot Face</h3>
    <img src="screenshot/face.png" width="175" alt="BetterMood">
    &nbsp;
    <img src="screenshot/face_2.PNG" width="175" alt="BetterMood">
    <h3>Einstein 3D Face</h3>
    <img src="screenshot/face_3.png" width="175" alt="BetterMood">
    &nbsp;
    <img src="screenshot/face_4.PNG" width="175" alt="BetterMood">
    <h3>Horoscope</h3>
    <img src="screenshot/face_5.PNG" width="175" alt="BetterMood">
    &nbsp;
    <img src="screenshot/face_6.PNG" width="175" alt="BetterMood">
</div>

## Instruction

> Backend is fully written in Python (Flask)

```Please edit 'app.config['MONGO_URI'] = "mongodb+srv://MONGO_DATA_BASE_URL"'```

```
$ git clone https://github.com/YosriGFX/BetterMood.git
$ cd BetterMood
$ cd backend
$ pip install -r requirements.txt
$ python3 app.py
```

> Frontend is fully written in Swift

```Please edit 'let domain = "URL_API"' with your end_point```

```
$ cd ..
$ cd iOS_app
$ pod install
$ open BetterMood.xcworkspace
```

---

```Proudly written by Yosri Ghorbel```

![Yosri Ghorbel](https://pbs.twimg.com/media/E3YEO7kXwAU9x6x?format=png&name=4096x4096)

> Copyright © 2021 [Yosri.dev](https://Yosri.dev). All rights reserved.
