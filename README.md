# Depth-Recognition
Applet that identifies relative distance from a webcam using edge detection, using dynamic time warping and the Microsoft Kinect sensor.

## Goal
To help Yoga Users keep a straight back when performing the Sukhasana pose. This pose requires sitting down, crossing one's legs and keeping one's back straight. 

## Tools

[Processing](http://www.wekinator.org/examples/#BBC_microbit)

[Wekinator](http://www.wekinator.org/examples/)

[Microsoft Kinect](https://developer.microsoft.com/en-us/windows/kinect)

## Problem-solving approach
Using the Microsoft Kinect and Audio Outputs we aim to provide people to better their Sukhasana pose. Based on what physical yoga position your back is at diffrent audio sounds will output providing you feedback in a non-intrusive way. Different sounds will play for whether or not your back is straight or slanted, giving you feedback to improve your pose.

### Sensors
We used the Microsoft Kinect to track our bodies and more specificly our backs to check if they are straight or not. We originally intended to use the XYZ coordinates of the user relative to the screen in order to create a virtual 'skeleton' of anyone using the trainer. However, we were unable to map all necessary components within our program to extract this feature. This is why used a different type offeature extraction: the relative depth of a person in relation to the kinect sensor itself.

## Results
In terms of our processing code, the project was a success. We were able to create a depth recognition program that tracks the user's distance from the sensor, and map it to a gradient spectrum color output. However, getting the Kinect to work with Wekinator was a major roadblock for us. Since we were unable to get the skeleton feature to work on our systems, we tried to do it with depth perception by averaging the representative color values for 100 blocks of depth pixels. There were some issues in terms of relaying the information to Wekinator in terms of differentiating between our various inputs (see data).

## Demo video

https://youtu.be/xIKrlje2bWM

