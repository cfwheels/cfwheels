-- ----------------------------------------------------------------------
-- MySQL Migration Toolkit
-- SQL Create Script
-- ----------------------------------------------------------------------

SET FOREIGN_KEY_CHECKS = 0;

CREATE DATABASE IF NOT EXISTS `wheelstestdb`
  CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `wheelstestdb`;
-- -------------------------------------
-- Tables

DROP TABLE IF EXISTS `wheelstestdb`.`Users`;
CREATE TABLE `wheelstestdb`.`Users` (
  `Id` INT(10) NOT NULL AUTO_INCREMENT,
  `UserName` VARCHAR(50) NOT NULL,
  `Password` VARCHAR(50) NOT NULL,
  `FirstName` VARCHAR(50) NOT NULL,
  `LastName` VARCHAR(50) NOT NULL,
  `Address` VARCHAR(100) NULL,
  `City` VARCHAR(50) NULL,
  `State` CHAR(2) NULL,
  `ZipCode` VARCHAR(50) NULL,
  `Phone` VARCHAR(20) NULL,
  `Fax` VARCHAR(20) NULL,
  `BirthDay` DATETIME NULL,
  `BirthDayMonth` INT(10) NULL,
  `BirthDayYear` INT(10) NULL,
  `BirthTime` DATETIME NULL DEFAULT '2000-01-01 18:26:08.690',
  `IsActive` BIT NULL,
  PRIMARY KEY (`Id`)
)
ENGINE = INNODB;

DROP TABLE IF EXISTS `wheelstestdb`.`PhotoGalleries`;
CREATE TABLE `wheelstestdb`.`PhotoGalleries` (
  `photogalleryid` INT(10) NOT NULL AUTO_INCREMENT,
  `userid` INT(10) NOT NULL,
  `title` VARCHAR(255) NOT NULL,
  `description` LONGTEXT NOT NULL,
  PRIMARY KEY (`photogalleryid`)
)
ENGINE = INNODB;

DROP TABLE IF EXISTS `wheelstestdb`.`PhotoGalleryPhotos`;
CREATE TABLE `wheelstestdb`.`PhotoGalleryPhotos` (
  `photogalleryphotoid` INT(10) NOT NULL AUTO_INCREMENT,
  `photogalleryid` INT(10) NOT NULL,
  `filename` VARCHAR(255) NOT NULL,
  `description` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`photogalleryphotoid`)
)
ENGINE = INNODB;

DROP TABLE IF EXISTS `wheelstestdb`.`Posts`;
CREATE TABLE `wheelstestdb`.`Posts` (
  `id` INT(10) NOT NULL AUTO_INCREMENT,
  `authorid` INT(10) NULL,
  `title` VARCHAR(250) NOT NULL,
  `body` LONGTEXT NOT NULL,
  `createdat` DATETIME NOT NULL,
  `updatedat` DATETIME NOT NULL,
  `deletedat` DATETIME NULL,
  `views` INT(10) NOT NULL DEFAULT 0,
  `averagerating` FLOAT(53) NULL,
  PRIMARY KEY (`id`)
)
ENGINE = INNODB;

DROP TABLE IF EXISTS `wheelstestdb`.`Authors`;
CREATE TABLE `wheelstestdb`.`Authors` (
  `id` INT(10) NOT NULL AUTO_INCREMENT,
  `firstname` VARCHAR(100) NOT NULL,
  `lastname` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`)
)
ENGINE = INNODB;

DROP TABLE IF EXISTS `wheelstestdb`.`Classifications`;
CREATE TABLE `wheelstestdb`.`Classifications` (
  `id` INT(10) NOT NULL AUTO_INCREMENT,
  `postid` INT(10) NOT NULL,
  `tagid` INT(10) NOT NULL,
  PRIMARY KEY (`id`)
)
ENGINE = INNODB;

DROP TABLE IF EXISTS `wheelstestdb`.`Comments`;
CREATE TABLE `wheelstestdb`.`Comments` (
  `id` INT(10) NOT NULL AUTO_INCREMENT,
  `postid` INT(10) NOT NULL,
  `body` LONGTEXT NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `url` VARCHAR(100) NULL,
  `email` VARCHAR(100) NULL,
  `createdat` DATETIME NOT NULL,
  PRIMARY KEY (`id`)
)
ENGINE = INNODB;

DROP TABLE IF EXISTS `wheelstestdb`.`Profiles`;
CREATE TABLE `wheelstestdb`.`Profiles` (
  `id` INT(10) NOT NULL AUTO_INCREMENT,
  `authorid` INT(10) NULL,
  `dateofbirth` DATETIME NOT NULL,
  `bio` LONGTEXT NULL,
  PRIMARY KEY (`id`)
)
ENGINE = INNODB;

DROP TABLE IF EXISTS `wheelstestdb`.`Tags`;
CREATE TABLE `wheelstestdb`.`Tags` (
  `id` INT(10) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  `description` VARCHAR(50) NULL,
  PRIMARY KEY (`id`)
)
ENGINE = INNODB;

DROP TABLE IF EXISTS `wheelstestdb`.`Cities`;
CREATE TABLE `wheelstestdb`.`Cities` (
  `CountyId` CHAR(4) NOT NULL,
  `CityCode` TINYINT(3) NOT NULL,
  `Name` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`CountyId`, `CityCode`)
)
ENGINE = INNODB;

DROP TABLE IF EXISTS `wheelstestdb`.`Shops`;
CREATE TABLE `wheelstestdb`.`Shops` (
  `ShopId` CHAR(9) NOT NULL,
  `CityCode` TINYINT(3) NULL,
  `Name` VARCHAR(80) NOT NULL,
  PRIMARY KEY (`ShopId`)
)
ENGINE = INNODB;



-- -------------------------------------
-- Views

DROP VIEW IF EXISTS `wheelstestdb`.`userphotos`;
create view userphotos
as
select
	u.id as userid
	,u.username as username
	,u.firstname as firstname
	,u.lastname as lastname
	,pg.title as title
	,pg.photogalleryid as photogalleryid
from
	users u
	inner join photogalleries pg
		on u.id = pg.userid;



SET FOREIGN_KEY_CHECKS = 1;

-- ----------------------------------------------------------------------
-- EOF