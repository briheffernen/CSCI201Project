DROP SCHEMA IF EXISTS Final;

CREATE SCHEMA Final;
USE Final;
CREATE TABLE users (
userID int(11) primary key not null auto_increment,
userName varchar(50) not null
);
CREATE TABLE meeting (
meetingID int(11) primary key not null auto_increment,
meetingTime varchar(50) not null,
meetingTime varchar(50) not null
);
CREATE TABLE meeting_users(
FOREIGN KEY fk1(meetingID) REFERENCES meeting(meetingID),
FOREIGN KEY fk1(userID) REFERENCES users(userID)
)
