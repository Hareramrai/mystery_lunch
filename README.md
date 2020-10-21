# Mystery Lunch Matching Application

## About

This is a Ruby on Rails application, which helps to create mystery matches for employees.
Mystery lunch is part of the creditshelf culture: at the beginning of each month, every employee is
randomly selected to have lunch with another employee of a different department.
Mystery Lunch web application is going to accomplish this process of matching.

We have used a sampling technique for matching employees for lunch & used devise for authentication.

Application deployed at https://mysterylunch.herokuapp.com/ .

## System dependencies

1. `Ruby 2.7.1`
2. `Rails 6.0.3`
3. `Postgres`
4. `Docker for Mac`
5. `NODEJS`
6. `YARN`

## Development Setup

- Build Docker

  `docker-compose build`

- Database creation

  `docker-compose run web rake db:setup`

- Start the Application
  `docker-compose up`

## How to run the test suite

`docker-compose run web bash`
`SIMPLECOV=true RAILS_ENV=test rspec`

### Data Modeling

![Data Model](data_model.png)

#### Department

This model is used to represent a department and also had a relation with the user to keep track of the manager of a department.
Also, I have used `citext` for case insensitive indexing for department names.

#### User

This model is used to represent a user & had fields required for authentication as well.
Every user belongs to a department and has many mystery matches.

#### MysteryMatch

It's a kind of join table, which keeps tracks of an employee and a lunch team.

##### LunchTeam

It belongs to lunch and used to hold a group of employees that are matched for a monthly team lunch.

#### Lunch

It's used to keep track of monthly lunch & could be used to store the restaurant location.
It has many lunch teams, which means a list of all different employees that are made as partners for this lunch.

### Implementation Logic for Matching

I am doing a few things to match an employee with another or a pair of two.
So, the steps can be summarized as follows.

1. Load employee with his last three partner

2. Get the list of pending employees except for his current department

3. Call `Mystery::FindPartnerService` with the list of employees from point 2 and current employee.
   Then the finder service uses sampling technique to select random employee after rejecting last three partners.

4. If got an employee then it's going to be a partner & we store those lists of employees in an array. But when we got nothing then we selected employees will be moved to the failed lists. This normally happens when we ran out of partners.Also, we marked the partner as matched.

5. Then we try to find the partner for a failed employees with existing employee-partners of two pairs. Also, update the array if we got any match.

6. At last, we used `Mystery::CreateMatchesService` service to batch import the matchings.

## Patterns of Development

I personally try to keep things simple and small as much as possible. I am a fan of DRY but don't like to go super dry.

Now, I would like to share my thought on the service directory in this application.

Btw I am a good believer in the single responsibility principle & prefer to have a number of classes instead of having a giant single class.

### Services

Services are PORO and used to perform the operation which is not suitable for model and controller and must adhere to the single responsibility principle.

I prefer to expose only one endpoint from the service that would be invoked.

#### app/services/mystery/\*

This directory of services has all services which are used to perform matching or removing future matching in case an employee gets deleted.

`Mystery::AddEmployeeToLunchService` is used when a new employee is created & we have to find a partner for him.

`Mystery::FindPartnerInTeamService` is used when we have an odd number of employees & had to find a 3 pair of mystery partners.

`Mystery::DeleteEmployeeFromLunchService` is used when deleting an employee which has future lunch. We do nothing for older matchings.

`ExchangeEmployeePartnerService` is used to exchange partners of given employees if they match the criteria.

#### app/services/SampleDataLoaderService

I prefer to create a service for sample data because we can test it and it's more manageable than normal `seeds.rb`.

## Feature of your choice

I have added features to exchange my current partner with other partners from the different departments & I have not been matched recently. This feature will be available when a logged-in employee visits the profile page of another.
Then there will be a button to exchange the partner. If partner criteria are matched then it will exchange the partner otherwise it will show an alert message.

## Deployment instructions

- `git push heroku master`

## Area of improvement

1. Adding pundit for authorization.
2. Bullet gem can be added to improve the complete operation if introduce N+1 problem.
3. We could try to refactor the scheduler service to smaller parts.
4. Pagination for the match listing page.
