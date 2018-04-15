DROP DATABASE if exists StudySpots;

CREATE DATABASE StudySpots;

USE StudySpots;

CREATE TABLE Location (
  locationID int(11) primary key not null auto_increment,
  locName varchar(255) not null
);

INSERT INTO Location (locName) VALUES ('Birnkrant');

CREATE TABLE Users (
	userID int(11) primary key not null auto_increment, 
    userName varchar(50) not null 
);

INSERT INTO Users (userName) VALUES ('Bri Heff');

CREATE TABLE LocationReviews (
	LocationReviewsId int(11) primary key not null auto_increment, 
	locationID int(11) not null,
	userID int(11) not null,
    review varchar(180) not null,
	FOREIGN KEY fk1(locationID) REFERENCES Location(locationID),
	FOREIGN KEY fk2(userID) REFERENCES Users(userID)
);

INSERT INTO LocationReviews (locationID, userID, review) VALUES (1, 1, 'This place is kind of stressful to study in...');
