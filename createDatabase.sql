DROP SCHEMA IF EXISTS Final;

CREATE SCHEMA Final;
USE Final;
CREATE TABLE users (
userID varchar(50) primary key not null,
userName varchar(50) not null,
access_token varchar(150) not null,
refresh_token varchar(150)
);

CREATE TABLE Location (
  locationID int(11) primary key not null auto_increment,
  locName varchar(255) not null
);

CREATE TABLE meeting (
meetingID int(11) primary key not null auto_increment,
meetingTime DATETIME not null,
meetingLocation varchar(50) not null,
locationID int(11) not null,
meetingName varchar(50) not null,
teamID int(11) not null,
FOREIGN KEY fk1(locationID) REFERENCES Location(locationID)
);

CREATE TABLE meeting_users(
meetingId int(11) not null,
userID varchar(50) not null,
FOREIGN KEY fk1(meetingID) REFERENCES meeting(meetingID),
FOREIGN KEY fk2(userID) REFERENCES users(userID)
);
CREATE TABLE LocationReviews (
	LocationReviewsId int(11) primary key not null auto_increment, 
	locationID int(11) not null,
	userID VARCHAR(50) not null,
    	review varchar(180) not null,
	FOREIGN KEY fk1(locationID) REFERENCES Location(locationID),
	FOREIGN KEY fk2(userID) REFERENCES users(userID)
);
CREATE TABLE Team (
	teamID INT(11) PRIMARY KEY NOT NULL AUTO_INCREMENT,
	teamName VARCHAR(50) NOT NULL
);

CREATE TABLE TeamMembers(
	userID VARCHAR(50) NOT NULL,
	teamID INT(11) NOT NULL
);


INSERT INTO Location (locName) VALUES ('Birnkrant Residental College'); 
INSERT INTO Team (teamName) VALUES ('test team!'); 
INSERT INTO meeting (meetingTime, meetingLocation, locationID, meetingName, teamID) VALUES ('2018-04-16 12:00:00', 'Birnkrant Residental College', 1, 'Test Meeting', 1);
