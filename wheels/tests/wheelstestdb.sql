USE [wheelstestdb]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Users]') AND type in (N'U'))
DROP TABLE [dbo].[Users]
go
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PhotoGalleries]') AND type in (N'U'))
DROP TABLE [dbo].[PhotoGalleries]
go
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PhotoGalleryPhotos]') AND type in (N'U'))
DROP TABLE [dbo].[PhotoGalleryPhotos]
go
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Posts]') AND type in (N'U'))
DROP TABLE [dbo].[Posts]
go
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Authors]') AND type in (N'U'))
DROP TABLE [dbo].[Authors]
go

/***********************************************
		building tables
***********************************************/
--Users
CREATE TABLE [dbo].[Users](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [varchar](50) NOT NULL,
	[Password] [varchar](50) NOT NULL,
	[FirstName] [varchar](50) NOT NULL,
	[LastName] [varchar](50) NOT NULL,
	[Address] [varchar](100) NULL,
	[City] [varchar](50) NULL,
	[State] [char](2) NULL,
	[ZipCode] [varchar](50) NULL,
	[Phone] [varchar](20) NULL,
	[Fax] [varchar](20) NULL,
	[BirthDay] [datetime] NULL,
	[BirthDayMonth] [int] NULL,
	[BirthDayYear] [int] NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
go
-- PhotoGalleries
CREATE TABLE [dbo].[PhotoGalleries](
	[photogalleryid] [int] IDENTITY(1,1) NOT NULL,
	[userid] [int] NOT NULL,
	[title] [varchar](255) NOT NULL,
	[description] [text] NOT NULL,
 CONSTRAINT [PK_PhotoGalleries] PRIMARY KEY CLUSTERED 
(
	[photogalleryid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
go

-- PhotoGalleryPhotos
CREATE TABLE [dbo].[PhotoGalleryPhotos](
	[photogalleryphotoid] [int] IDENTITY(1,1) NOT NULL,
	[photogalleryid] [int] NOT NULL,
	[filename] [varchar](255) NOT NULL,
	[description] [varchar](255) NOT NULL,
 CONSTRAINT [PK_photogalleryphotos] PRIMARY KEY CLUSTERED 
(
	[photogalleryphotoid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
go

-- Posts
CREATE TABLE [dbo].[Posts](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[authorid] [int] NOT NULL,
	[title] [varchar](250) NOT NULL,
	[body] [text] NOT NULL,
	[createdat] [datetime] NOT NULL,
	[updatedat] [datetime] NULL,
 CONSTRAINT [PK_Posts] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
go

-- Authors
CREATE TABLE [dbo].[Authors](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[firstname] [varchar](100) NOT NULL,
	[lastname] [varchar](100) NOT NULL,
 CONSTRAINT [PK_Authors] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
go



/*****
	Generating test data
*****/



-- Users
SET IDENTITY_INSERT Users ON

insert into Users (id, username, password, firstname, lastname, address, city, state, zipcode, phone, fax, birthday, birthdaymonth, birthdayyear) values
(1, 'tonyp', 'tonyp123', 'Tony', 'Petruzzi', '123 Petruzzi St.', 'SomeWhere1', 'TX', '11111', '1235551212', '4565551212', '11/01/1975', 11, 1975)

insert into Users (id, username, password, firstname, lastname, address, city, state, zipcode, phone, fax, birthday, birthdaymonth, birthdayyear) values
(2, 'chrisp', 'chrisp123', 'Chris', 'Peters', '456 Peters Dr.', 'SomeWhere2', 'LA', '22222', '1235552323', '4565552323', '10/05/1972', 10, 1972)

insert into Users (id, username, password, firstname, lastname, address, city, state, zipcode, phone, fax, birthday, birthdaymonth, birthdayyear) values
(3, 'perd', 'perd123', 'Per', 'Djurner', '789 Djurner Ave.', 'SomeWhere3', 'CA', '44444', '1235554545', '4565554545', '09/12/1973', 9, 1973)

insert into Users (id, username, password, firstname, lastname, address, city, state, zipcode, phone, fax, birthday, birthdaymonth, birthdayyear) values
(4, 'raulr', 'raulr23', 'Raul', 'Riera', '987 Riera Blvd.', 'SomeWhere4', 'WI', '55555', '1235558989', '4565558989', '06/14/1981', 6, 1981)

insert into Users (id, username, password, firstname, lastname, address, city, state, zipcode, phone, fax, birthday, birthdaymonth, birthdayyear) values
(5, 'joeb', 'joeb', 'Joe', 'Blow', '123 Petruzzi St.', 'SomeWhere4', 'CA', '22222', '1235551212', '4565554545', '11/12/1973', 11, 1973)

SET IDENTITY_INSERT Users OFF

-- PhotoGalleries & PhotoGalleryPhotos
declare
	@id int
	,@firstname varchar(50)
	,@photogalleryid int
	,@photoid int
	,@sql varchar(4000)
	,@photogalleryid_ varchar(10)
	,@photoid_ varchar(10)
	,@id_ varchar(10)
	,@x int
	,@y int

set @photogalleryid = 1
set @photoid = 1

declare photos cursor for
select id, firstname from users

open photos

fetch next from photos into @id, @firstname

while @@fetch_status = 0
	begin
		set @x = 1
		set @id_ = cast(@id as varchar(10))

		while (@x <= 5)
			begin
				set @y = 1
				set @photogalleryid_ = cast(@photogalleryid as varchar(10))
				
				set @sql = 'insert into PhotoGalleries (photogalleryid, userid, title, description) values ('+@photogalleryid_+', '+@id_+', '''+@firstname+' Test Galllery '+@photogalleryid_+''', ''test gallery '+@photogalleryid_+' for '+@firstname+''')'
				SET IDENTITY_INSERT PhotoGalleries ON
				exec(@sql)
				SET IDENTITY_INSERT PhotoGalleries OFF
				
				while (@y <= 10)
					begin
						set @photoid_ = cast(@photoid as varchar(10))
						set @sql = 'insert into PhotoGalleryPhotos (photogalleryphotoid, photogalleryid, filename, description) values ('+@photoid_+', '+@photogalleryid_+', ''Gallery '+@photogalleryid_+' Photo Test '+@photoid_+''', ''test photo '+@photoid_+' for gallery '+@photogalleryid_+''')'
						SET IDENTITY_INSERT PhotoGalleryPhotos ON
						exec(@sql)
						SET IDENTITY_INSERT PhotoGalleryPhotos OFF
						set @y = @y + 1
						set @photoid = @photoid + 1
					end

				set @x = @x + 1
				set @photogalleryid = @photogalleryid + 1
			end

		fetch next from photos into @id, @firstname	
	end

close photos
deallocate photos


