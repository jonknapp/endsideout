# 0001. Use Separate Model And Authentication For Students

Date: 2026-05-09

## Authors

- Sean Dickinson

## Context

Students are a very different type of user compared to administrators. Some students using the application may have low reading comprehension and struggle with basic typing skills. 
They also may not all have email addresses and be able to remember passwords.

The goal is to make the student login process as simple and frictionless as possible. There is no real need for security, as the application does not contain any sensitive information tied to students.
There also is no incentive for a student to login as another student, as they can only earn rewards via their actions in the application. 
There are no actions they take in the application would cause the logged in account to lose rewards or cause any negative consequences for another student.

## Decision
- We will create a separate model for students, and use a simple authentication system that does not require email addresses or passwords.
- The students will be provided a unique link to the login page for their class, and will be able to select their name from a list of students in their class to log in.
- From the perspective of the application, students will be a separate type of user with their own authentication system, and will not be able to access any of the administrator features or data.
- Students will have their own session model and authentication concern that is separate from the administrator session model and authentication concern so there is no risk of students being able to access administrator features.
- We will use Rails' built-in authentication scaffold for the administrator authentication system
- We will use a modified version of the Rails' built-in authentication scaffold for the student authentication system that is tailored to the needs of students.

## Consequences

- This approach allows us to provide a simple and user-friendly login experience for students, while still maintaining a clear separation between students and administrators in the application.
- We will have to maintain and support 2 separate authentication systems and sets of models