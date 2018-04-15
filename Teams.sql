DROP DATABASE IF EXISTS Teams;
CREATE DATABASE Teams;
USE  Teams;

CREATE TABLE Team (
	teamID INT(11) PRIMARY KEY NOT NULL,
	teamName VARCHAR(50) NOT NULL
);

CREATE TABLE TeamMembers (
	memberID INT(11) PRIMARY KEY NOT NULL,
    memberNAME VARCHAR(50) NOT NULL,
    teamID INT(11) NOT NULL
    );
    
    INSERT INTO Team (teamID, teamName) VALUES (1, '201Project');
    INSERT INTO TeamMembers (memberID, memberName, teamID) VALUES (1, 'chochola', 1);
    INSERT INTO TeamMembers (memberID, memberName, teamID) VALUES (2, 'brihef', 1);
    