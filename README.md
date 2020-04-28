# IRecognize

## Product Description 🔬

IRecognize is made for my CP469 IPhone Application Programming course. The applications goal is to make item recognition simple for users of all ages whetherthey are a kid or adult. As a student, I am still continually learning new things such as about the resisters and their color codes when I took CP220 which was a struggle and took a long time to make a project because much of my time was used for finding the correct chips. With this app, I want to solve this problem in a world where the ideation of new and innovative products are entering this world by making an application that can detect the object in focus within an image and assist the user in being able do identify what it is. It utilizes Apples machine learning models and XCodes Augmented reality application development kit to label items within the screen in AR. 

## Prerequisites 

- [XCode](https://developer.apple.com/xcode/ide/) - IDE
- [Phone](https://www.apple.com/ca/) - Apple IOS device 
- [Resnet50 ML Model](https://developer.apple.com/machine-learning/models/) - Machine Learning Model

## Installation 

Option 1:

```bash
$ git clone https://github.com/Edmund-Lui98/IRecognize.git
```

Option 2:

[Download the Repository as a ZIP File](https://github.com/Edmund-Lui98/IRecognize/archive/master.zip).

## Running the application

Open the IRecognize folder in XCode and download the Machine Learning model from Apple

[Download Resnet50 Image classification model](https://developer.apple.com/machine-learning/models/).

Drag the Resnet50 model into XCode Folder
- Copy into same folder as the View Controller 
- Click "Copy items if needed"

![resnet1](https://user-images.githubusercontent.com/48935039/80428492-f9d37900-88b7-11ea-8003-1ca6ad417c42.jpg)

Build and install onto an IOS device with a functioning camera

## Functionality 

The first screen when the app is opened has two buttons as shown below.

![img3](https://user-images.githubusercontent.com/48935039/80431042-5a65b480-88be-11ea-97e1-fa57106e98c5.jpg)

The "Start" button segues into the main functionality of the app.

![img2](https://user-images.githubusercontent.com/48935039/80431021-520d7980-88be-11ea-9fc1-6c8b61394829.jpg)

The phone will ask the user for permissions and start the camera on the screen. 

![img1](https://user-images.githubusercontent.com/48935039/80430992-4326c700-88be-11ea-8b64-5fa49caaeacb.jpg)

Functionalities:

- Camera Screen
  - Tapping on the camera screeen will add an Augmented Reality label on the location touched
  - The label will read a prediction of the item in focus 
  - The machine learning model does not have much data so it can be inaccurate at times. In understanding this, I have put an input box at the bottom of the screen in which if there is text typed into it, tapping on the camera screen will add a label of the inputted text instead of the Resnet50 prediction
  
- Object Label
  - The label underneath the camera screen shows two parts of the prediction.
  - The first word in the label is the name of the predicted item
  - The second part is the confidence interval of the machine learning model (shown in percentage) of how accurate the model predicts the object
  
- Show/Hide Button
  - This button toggles the label button to show or hide the text because it can get annoying to look at
  
- Speak Button
  - This button will speak out loud the prediction in place at the time the button is pressed

Unfortunately, due to time constraints I did not get to put this information in the "About" section.
  
## Whats next?

As a software developer, it is important to think about the future of my projects and here are a few ideas I want to continue to implement in the future within this app:
- Allow the user to remember items that have been previously labelled and add an additional menu selection to show what has been stored (Add and delete saved items) 
- Implement user authentication and store saved items in a database most likely using the Google Cloud Platforms (Firebase, Firestore)
- Allow option to add a picture from the phone gallery to made a prediction of the objects in the image
- Add button to search up an item on the web
- Add other AR items other than labels, such as 3D objects (would need to find an API that stores 3D objects to pull from)
- Understanding that this ML model is very limited due to lack of data, create my own ML model (CNN) that can use and be trained from users data (Tensorflow)
