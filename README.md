# About

A marking system is essential for aiding students aiming to achieve high marks. Accurate yet updated grades will allow students to have an overview of their work. The system should obtain data from other sources such as Web Submission to calculate their current overall grade based on assessment criteria.

The goal of this system is to allow students to view their assessments and feedback without visiting a number of different websites. We aim to primarily have integration with the Canvas API and allow for the importation and exportation of grades via spreadsheets.

This project will provide markers with a student marking system to upload and manage marks on a database that is available for student viewing. Students will also be allowed to see how well they performed compared to other students and be able to calculate their final grade based on predicted scores.

## Required Ruby Version

Ruby 2.6.5

## Install Instructions

First install the gem dependencies using `bundle install`

Ensure that the database is up to date with the seeds using `rake db:drop db:create db:migrate db:seed`

Finally launch the server using `rails server`

The server should be running on port `3000`

## Test Suite

Execute Cucumber tests using `bundle exec cucumber`

Execute RSPEC tests using `bundle exec RSPEC`
