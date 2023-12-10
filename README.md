# Reverb and Delay Calculator

Simple and elegant modern app for calculating reverb and delay time.

## Description

The application is designed for musicians and mixing engineers to help calculate reverb and delay time according to the tempo.
Syncing reverb and delay time to the tempo of the song is essential to achieve professional grade results.
Yet, a large percentage of vintage delay units, most of guitar pedals as well as the majority of reverb units both old and new provide no ability to sync the tail to the tempo.
This is where Reverb and Delay calculator comes in handy.

## Functionality

- Calculate reverb and delay time in miliseconds and displays them in a table of note lengths ranging from 1/16 to 8 bars in 4/4 time.
- Use handy metronome if working without a master clock (e.g. live band)
- Use tap tempo to determine the tempo of the track if the actual value is unknown

## Screenshots

<div>
<p><strong>App:</strong></p>
  <img src="https://raw.githubusercontent.com/maniutin/reverb_calculator/main/assets/screenshots/reverb_page.png" width="400" alt="Reverb Page">
  <img src="https://raw.githubusercontent.com/maniutin/reverb_calculator/main/assets/screenshots/delay_page.png" width="400" alt="Delay Page">
</div>

<p><strong>Logo:</strong></p>
<img src="https://raw.githubusercontent.com/maniutin/reverb_calculator/main/assets/logos/main-trimmed.png" width="400" alt="Logo">

<p><strong>Video Demo:</strong></p>

[YouTube](https://youtube.com/shorts/TtVuXrpkKH0?feature=share)

## Stack

The app is built in Flutter.
Additional packages used:

- [Number Picker](https://pub.dev/packages/numberpicker)
- [Metronome](https://pub.dev/packages/metronome)

## Upcoming features

- storing last used tempo in local storage to preserve it in-between sessions
- customize the color scheme to make the app truly your own
- add preview to check the desired effect length without having to dial it into your own devices
