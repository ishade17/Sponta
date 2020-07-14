Original App Design Project - README Template
===

# Sponta

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
Sponta is a platform that facilitates spontaneous excursions among friend groups. A user can post a trip their planning on taking (either the day of or the day before) along with the number of spots available and picture previews of the destination to a centralized feed where the user's friends can join the trip. Then once user initiates the trip the app will plot out a route using Google Maps. Finally, after the trip, the trip participants can submit their photos to the trip organizer to post as a photo album.

### App Evaluation
[Evaluation of your app across the following attributes]
- **Category:** Social Networking
- **Mobile:** iOS
- **Story:** This app was inspired after my roomate was struggling to plan a last minute trip to Big Sur.
- **Market:** This app would be most used for young people (teens, college, 20s) because this is the age group that has the most group outings. People above this age have less spontaneous outings and are with their family.
- **Habit:** This app handles much of the job of assembling a friends and organizing group outings.
- **Scope:** This app includes many wireframes, using maps, adding photos to a feed, chatting. So it will definitely take the four weeks.

## Product Spec

### 1. User Stories (Required and Optional)

Sponta Action Items:
https://docs.google.com/document/d/14EbyAwkXVvlrD8Ms6i43bIkaImHW_jv6cGUVf0MC-HM/edit

**Required Must-have Stories**

* User can post a new trip to their feed
* User can create a new account
* User can create a new account
* User can search for other trips in the area
* User can like a trip
* User can follow/unfollow another user
* User can view a feed of trips
* User can create a trip  
* User can view other user’s profiles (and their own) to see their photo albums
* User can tap a trip post to view a more detailed trip screen with comments
* User can view upcoming trips

**Optional Nice-to-have Stories**

* User can search for photos by a trip destination
* User can see notifications when their photo is liked, they are followed, or someone joins/leaves their trip list
* User can see a list of their followers
* User can see a list of their following

### 2. Screen Archetypes
SPONTA UI MOCK UP: 
https://www.figma.com/file/XWEi7z6vDzomLnfJhgC5RN/Sponta-UI?node-id=0%3A1

* Login Screen
    * User can login
* Registration Screen
    * User can create a new account
* Stream
    * User can view a feed of trips with preview photos
    * User can double tap a trip post to like
* Details
    * User can tap a trip post to view its details and route
    * User can leave comment on the trip post and view other comments
* Creation
    * User can build a new trip post by filling out the details
    * User can add preview photos to their new trip post
* Search
    * User can search for other users
    * User can search for other albums associated with a certain trip destination
* Notifications
    * User can view who has joined and left their trip list
    * User can view who has liked and commented on their trip post
* Profile
    * User can view their photo albums from past trips
    * User can view their upcoming and planned trips

### 3. Navigation

**Tab Navigation** (Tab to Screen)


* Home feed
* Search
* Create Trip
* Notifications
* Profile

**Flow Navigation** (Screen to Screen)

* Login / Registration Screen
    * Home feed
* Trip Post
   * Trip details with comments
* Creation Screen
    * Fill out details
    * Add preview photos
* Profile
    * Albums Preview
        * Album Post
    * Upcoming / Planned trips
        * Edit trip
* Search: Profile or Destination
    * Searched Profile
    * Destination Album
* Notifications
    * Leave trip button
    * Contribute to photo album

## Wireframes
See below.

### [BONUS] Digital Wireframes & Mockups
SPONTA UI MOCK UP: 
https://www.figma.com/file/XWEi7z6vDzomLnfJhgC5RN/Sponta-UI?node-id=0%3A1

### [BONUS] Interactive Prototype

## Schema 
[This section will be completed in Unit 9]
### Models
Post.h
| Type | name | description
| --- | --- | --- |
| NSString | *postID | unique ID for each post |
| NSString | *userID | unique ID for each user |
| PFUser | *author | user information |
| NSString | *caption | description of the trip |
| PFFileObject | *previewImage | trip preview photo |
| NSNumber | *likeCount | number of likes for a trip post |
| NSNumber | *commentCount | number of comments on a trip post |
| NSString | *startPoint | beginning point of the trip |
| NSString | *endPoint | ending point of the trip |
| NSString | *startTime | beginning time of the trip |
| NSString | *endTime | ending time of the trip |
| NSString  | *tripTitle | title of the trip |

Comment.h
| Type | name | description
| --- | --- | --- |
| PFUser | *author | user who left the comment |
| Post | *post | the post that is commented on |
| NSString | *message | the message in the comment |

### Networking
