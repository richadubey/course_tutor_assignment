# Course Tutor Assignment 

This is a small Rails application built as part of an assignment. It allows you to create a course along with its tutors using a single POST API, and also fetch a list of all courses along with their tutors using a GET API.


## Problem Statement: Course and Tutor

Given 2 models - Course & Tutor
-A course can have many tutors.
-Tutor can teach one course only.

## Setup Instructions
### 1. Clone the repo

```bash
git clone https://github.com/richadubey/course_tutor_assignment.git
cd course_tutor_assignment
```

### 2. Install dependencies

```bash
bundle install
```

### 3. Set up the database

```bash
rails db:create
rails db:migrate
```

### 4. Run the server

```bash
rails server
```

## Postman Collection

I’ve exported a Postman collection with below APIs: 

1. Common POST API to create a course & its tutors
2. GET API to list all the courses along with their tutors

You can import the provided JSON file(course_tutor_assignment.postman_collection.json) into Postman 