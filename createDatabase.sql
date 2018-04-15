DROP SCHEMA IF EXISTS Final;

CREATE SCHEMA Final;
USE Final;
CREATE TABLE users (
userID varchar(50) primary key not null,
userName varchar(50) not null
);
CREATE TABLE meeting (
meetingID int(11) primary key not null auto_increment,
meetingTime varchar(50) not null,
meetingTime varchar(50) not null
);

CREATE TABLE meeting_users(
meetingId int(11) not null,
userID varchar(50) not null,
FOREIGN KEY fk1(meetingID) REFERENCES meeting(meetingID),
FOREIGN KEY fk1(userID) REFERENCES users(userID)
)
CREATE TABLE Location (
  locationID int(11) primary key not null auto_increment,
  locName varchar(255) not null
);
CREATE TABLE LocationReviews (
	LocationReviewsId int(11) primary key not null auto_increment, 
	locationID int(11) not null,
	userID int(11) not null,
    	review varchar(180) not null,
	FOREIGN KEY fk1(locationID) REFERENCES Location(locationID),
	FOREIGN KEY fk2(userID) REFERENCES users(userID)
);
CREATE TABLE Team (
	teamID INT(11) PRIMARY KEY NOT NULL,
	teamName VARCHAR(50) NOT NULL
);

CREATE TABLE TeamMembers(
	userID INT(11) NOT NULL,
	teamID INT(11) NOT NULL,
	FOREIGN KEY fk1(userID) REFERENCES users(userID),
	FOREIGN KEY fk2(teamID) REFERENCES Team(teamID)
);

