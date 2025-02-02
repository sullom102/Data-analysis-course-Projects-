
/*

Database Structure

Creating Database & Table information & Constraints for Donations and Donors (NGO)

מסד הנתונים - נתוני תרומות ותורמים, מבוסס על נתונים מדו"חות שנתיים של מלכ"ר 

*/

GO

USE MASTER

GO
IF EXISTS (SELECT * FROM SYSDATABASES WHERE NAME='Donations2023_DB')
		DROP DATABASE [Donations2023_DB];
GO

CREATE DATABASE [Donations2023_DB];

GO

USE [Donations2023_DB];

GO

CREATE TABLE [Categories]
(
	[CategoryID] INT IDENTITY (101,1) CONSTRAINT [Categoreis_CategoryID_PK] PRIMARY KEY,
	[CategoryName] VARCHAR(30) NOT NULL,
	[CategoryType] VARCHAR(20) NOT NULL,
	[CategoryDescription] NVARCHAR(70),
	CONSTRAINT [Categories_CategoryType_CK] CHECK (CategoryType IN ('Earmarked', 'Non Earmarked'))
);

GO


CREATE TABLE [FundsDesignation]
(
	[DesignationID] INT IDENTITY (401,1),
	[DesignationName] VARCHAR(50) CONSTRAINT [FundsDesignation_DesignationName_PK] PRIMARY KEY,
	[Description] VARCHAR(70),
	[ExpenseDeadline] DATE,
	[SpecialNotes] NVARCHAR(220)
);


GO

CREATE TABLE [Donors]
(
	[DonorID] INT IDENTITY(1,1) CONSTRAINT [Donors_DonorID_PK] PRIMARY KEY,
	[DonorName] VARCHAR(50) UNIQUE NOT NULL,
	[Category] INT NOT NULL,
	[AgreementEndDate] DATE, 
	[Designation_Name] VARCHAR(50),
	[ContactName] VARCHAR(20),
	CONSTRAINT [Donors_Category_FK] FOREIGN KEY (Category) REFERENCES Categories (CategoryID),
	CONSTRAINT [Donors_DesignationName_FK] FOREIGN KEY (Designation_Name) REFERENCES [FundsDesignation] (DesignationName)

);

GO 

CREATE TABLE [FundingInfo]
(
	[DonorName] VARCHAR(50) CONSTRAINT [FundingInfo_DonorName_PK] PRIMARY KEY,
	[DonorID] INT NOT NULL,
	[GrantRequested] MONEY,
	[GrantApproved] MONEY,
	[FirstInstallment] MONEY,
	[SecondInstallment] MONEY DEFAULT(0),
	[GrantType] VARCHAR(30) NOT NULL,
	[FirstInstallmentDate] DATE ,
	[SecondInstallmentDate] DATE, 
	CONSTRAINT [FundingInfo_DonorID_FK] FOREIGN KEY (DonorID) REFERENCES [Donors] (DonorID)

);                                          

GO

CREATE TABLE [DonorsInfo]
(
	[DonorName] VARCHAR(50) UNIQUE NOT NULL,
	[DonorDode] INT IDENTITY(1,1) CONSTRAINT [DonorsInfo_DonorCode_PK] PRIMARY KEY,
	[ContactPersonFullName] VARCHAR(20),
	[FirstGrantDate] DATE,
	[LinkedThrough] INT DEFAULT(NULL),
	[Phone] VARCHAR(12),
	[Email] VARCHAR(50),
	[Address] NVARCHAR (100),
	[Website] VARCHAR (100),
	CONSTRAINT [DonorsInfo_Email_CK] CHECK(Email LIKE '%@%' AND (Email LIKE '%.IL' OR Email LIKE '%.NET' OR Email LIKE '%.COM' OR Email LIKE '%.ORG')),
	CONSTRAINT [DonorsInfo_DonorDode_FK] FOREIGN KEY (DonorDode) REFERENCES [Donors] (DonorID),
	CONSTRAINT [DonorsInfo_LinkedThrough_FK] FOREIGN KEY (LinkedThrough) REFERENCES [DonorsInfo] (DonorDode)

);

GO

INSERT INTO [Categories]
VALUES 
		('Philanthropy Foundation', 'Earmarked', N'כסף צבוע מקרנות'),
		('Private Donors', 'Non Earmarked', N'תמיכות פרטיות מתורמים קטנים, כסף לא צבוע'),
		('Municipal', 'Earmarked', N'תמיכה מרשות מקומית (עיריית תא), כסף צבוע (ארנונה ואירועי שיא'),
		('Fundraising Event', 'Non Earmarked', N'אירוע התרמה שנתי לתמיכה כללית בעמותה'),
		('Crowdfunding', 'Earmarked', N'קמפיין גיוס המונים שנתי, כסף צבוע'),
		('Governmental', 'Earmarked', N'תמיכות ממשלתיות-קולות קוראים ומכזרים, כסף צבוע'),
		('Companies', 'Non Earmarked', N'תמיכה של חברות פרטיות,, לא צבוע'),
		('Individual Donor', 'Non Earmarked', N'תמיכה מתורמים פרטיים גדוולים, תמיכות כלליות לא צבועות')

;
GO


INSERT INTO [FundsDesignation]
VALUES 
		('Volunteers', 'Annual grants for volunteers', '2023-12-31', N'מענקי מתנדבים ומארגנים קהילתיים חוץ ממארגן של תא מפרץ חיפה'),
		('General Support', NULL, NULL, NULL),
		('Climate March', 'The annual climate march event', '2022-06-30', N'הוצאות לשלם עבור מצעד האקלים השנתי'),
		('Training Activities', 'Annual trainings for community organizers and Volunteers', NULL , N'כסף צבוע להכשרות שנתיות למארגנים ולמתנדבים עבור הכשרות 2022'),
		('Moving Offices', 'Support for moving costs to new offices', NULL, N'עלויות מעבר משרדים, גוסף גיטלר נתן בשנה שעברה 15,000'),
		('Leadership Program', 'Support for the leadership program', '2023-12-31', N'תכנית המנהיגות של עבור שנת 2023'),
		('Climate Action Program', 'Support activity for climate branch Campaign', NULL, NULL),
		('Public Transportaion Program','Support activity for Public Transportation Campaign', NULL, NULL),
		('Renewable Energy Program', 'Support activity for Renewable Energy branch',NULL, N' ישנה תמיכה משנת 2022 של קרן אריסון עבור 2023 של 12,000 שח'),
		('Recovery of Haifa Bay', 'Support activity for Haifa Bay Campaign', NULL, NULL),
		('Promoting Urban Renewal Negev District', 'Support the activity for Negev District Campaign', NULL, NULL),
		('Improving Digital Infrastructure', 'Support Improving digital assets and online visibility', '2023-12-31', N'הוצאות שצריכים לצאת בשנת 2023 עבור שיפורים של נכסים דיגיטליי, ריטיינר  של חברת מינוף'),
		('School of Activism', 'Support the expention and marketing of School of Activism',NULL, N'נשארה תמיכה של 30,000 שח לפיתוח עסקי של בית הספר לאקטיבזם')
;
		

GO


INSERT INTO [Donors]
VALUES 
		('Jgive', 102, NULL , 'General Support', 'Adi Gal'),
		('Israel Toremet', 102, '2026-12-31', 'General Support', 'Efrat Walach'),
		('Jewish Federation of North America', 101, '2024-10-31', 'Climate March', 'Beth Cohen'),
		('Rashi Foundation', 101, '2025-03-31', 'Leadership Program', 'Michal Ben-Ami'),
		('Beracha Foundation', 101, '2024-12-31', 'General Support', 'Adi Brill'),
		('Azrieli Foundation', 101, NULL, 'Public Transportaion Program', 'Anat Dror'),
		('Arison Foundation', 101, '2024-05-31', 'Training Activities', 'Leora Shavit'),
		('Governmental Appeals/Tenders', 106, NULL, 'Training Activities', NULL),
		('Tel Aviv-Yafo Municipality', 103, '2025-03-31', 'Climate March', 'Adi Ashkenazi'),
		('Headstart', 105, NULL, 'Renewable Energy Program', 'Yossef Roash'),
		('Google grants', 102, '2024-12-31', 'Moving Offices', 'Dvora Yarkoni'),
		('Fox Foundation', 101, '2025-09-30', 'Volunteers', 'Cheri Fox'),
		('Gitler family', 102, NULL, 'Volunteers', 'Jossef Gitler'),
		('The Joint', 102, '2024-10-31', 'General Support', 'David Bassa'),
		('Keren Ezvonot', 106, NULL, 'Recovery of Haifa Bay', NULL),
		('Igul Letova', 102, '2025-06-30', 'General Support', 'Dorit Hassid'),
		('GALA Event', 104, NULL, 'General Support', NULL),
		('UK Online Giving Foundation', 102, '2024-05-31', 'Climate Action Program', 'Ari Newman'),
		('Pratt Foundation', 101, '2024-12-31', 'Training Activities', 'Tamar Benbinisti'),
		('Rosa Luxemburg Foundation', 101, '2025-03-31', 'Climate Action Program', 'Ifat Yanai')
;

GO


INSERT INTO [FundingInfo]
VALUES 
		('Jgive',1 , NULL, NULL, NULL, DEFAULT , 'Pass-Through Grant', NULL, NULL),
		('Israel Toremet',2 , NULL, NULL, NULL, DEFAULT, 'Pass-Through Grant', NULL, NULL),
		('Jewish Federation of North America', 3, 250000, 250000, 125000, 125000, 'Continuation Grant', '2023-03-10', '2023-10-30'),
		('Rashi Foundation',4 , 50000, 50000, 30000, 20000, 'Continuation Grant', '2023-02-15', '2023-05-10'),
		('Beracha Foundation',5 , 300000, 250000, 50000, 200000, 'Continuation Grant', '2023-02-28', '2023-09-30'),
		('Azrieli Foundation', 6, 20000, 20000, 20000, 0, 'One-Time Grant', '2023-04-12', NULL),
		('Arison Foundation', 7, 70000, 70000, 45000, 25000, 'Continuation Grant', '2023-02-28', '2023-09-30'),
		('Governmental Appeals/Tenders', 8, 175000, 175000, NULL, 175000, 'One-Time Grant','2023-11-30', NULL),
		('Tel Aviv-Yafo Municipality', 9, 30000, 30000, 30000, 0, 'One-Time Grant', '2023-05-31', NULL),
		('Headstart', 10, 150000, NULL, NULL, DEFAULT, 'One-Time Grant', NULL, NULL),
		('Google grants', 11, 10000, 10000, 10000, 0, 'One-Time Grant', '2023-10-30', NULL),
		('Fox Foundation', 12, 115000, 70000, 35000, 35000, 'Continuation Grant', '2023-02-28', '2023-08-31'),
		('Gitler family', 13, 10000, 60000, 40000, 20000, 'Continuation Grant', '2023-03-30', '2023-09-30'),
		('The Joint', 14, 15000, 15000, 15000, 0, 'Formula Grant', '2023-12-20', NULL),
		('Keren Ezvonot', 15, 500000, 375000, 375000, 0, 'One-Time Grant', '2023-08-30', NULL),
		('Igul Letova', 16, NULL, NULL, NULL, NULL, 'Pass-Through Grant', NULL, NULL),
		('GALA Event', 17, 150000, NULL, NULL, NULL, 'One-Time Grant', NULL, NULL),
		('UK Online Giving Foundation', 18, 25000, 15000, 5000, 10000, 'Pass-Through Grant', NULL, NULL),
		('Pratt Foundation', 19, 200000, 200000, 100000, 100000, 'Continuation Grant', '2023-01-31', '2023-06-30'),
		('Rosa Luxemburg Foundation', 20, 32000, 25000, 15000, 10000, 'One-Time Grant', '2023-02-15', '2023-04-30')
;

GO



INSERT INTO [DonorsInfo]
VALUES 
		('Jgive', 'Sarit Gal', '2017-06-12', DEFAULT,'02-9662222', 'adi@jgive.com',N'דרך חברון 24, ירושלים, 91087','https://www.jgive.com'),
		('Israel Toremet', 'Efrat Walach', '2020-01-10', DEFAULT,'03-5184052', 'efrat@israeltoremet.org', N'העלייה 19, תל אביב יפו', 'https://www.israeltoremet.org/'),
		('Jewish Federation of North America', 'Beth Cohen', '2012-12-07', 13, '212.284.6500', 'bcohen@JewishFederations.org', N'25 Broadway, 17th Floor New York, NY 10004', 'https://www.jewishfederations.org/'),
		('Rashi Foundation', 'Michal Ben-Ami', '2015-08-30',DEFAULT, '08-9146600', 'michal@rashi.org.il', N'כפר הנוער בן-שמן מיקוד 7311200', 'https://rashi.org.il/'),
		('Beracha Foundation', 'Adi Brill', '2012-06-07', DEFAULT, '025631030', 'adi@beracha.org.il', N'עמק רפאים, 16, ירושלים, 9310508', 'https://berachafoundation.com/'),
		('Azrieli Foundation', 'Anat Dror', '2020-10-31', 13, '09-9705900', 'anat@azrieli.org', N'מדינת היהודים 85, הרצליה', 'https://www.azrielifoundation.org.il/'),
		('Arison Foundation','Leora Shavit', '2021-05-01', 12, '03-6073100', 'leora@arisonfoundation.org', N'שדרות שאול המלך 21, תל אביב 6436723', 'https://www.arisonfoundation.com/'),
		('Governmental Appeals/Tenders', NULL, NULL, DEFAULT, NULL , NULL, NULL, NULL),
		('Tel AvivYafo Municipality', 'Adi Ashkenazi', '2010-01-14', DEFAULT,'03-7242863', 'adi_a@mail.tel-aviv.gov.il', N'דיזנגוף 200, תל אביב', NULL),
		('Headstart', 'Yossef Roash', '2021-01-20', 14, '04-3731216', 'YossefRo@headstart.co.il', N'עמק חפר, צבי הנחל 231', 'https://headstart.co.il/'),
		('Google grants', 'Dvora Yarkoni', '2022-11-23', DEFAULT, '052-4667221', 'd_yarkon@ngos.google.com', N'יגאל אלון 98, תל אביב יפו', 'https://www.google.com/nonprofits/'),
		('Fox Foundation', 'Cheri Fox', '2015-05-25', DEFAULT, '03-775921', 'cherifox@foxfoundation.com', N'שד יהודית 21, תל אביב', 'https://www.michaeljfox.org/'),
		('Gitler family', 'Jossef Gitler', '2015-03-17', 12, '050-2815117', 'Jossef.g@gmail.com', NULL, NULL), 
		('The Joint', 'David Bassa', '2020-10-28', DEFAULT, '02-6557111', 'bassadavidisrael@jdc.org', N'אליעזר קפלן 9, גבעת רם, ירושלים', 'https://www.thejoint.org.il/'),
		('Keren Ezvonot', NULL, NULL, DEFAULT, '073-3926333', 'ezvonot3@justice.gov.il', N'צלאח א-דין 29, ת.ד. 49029, ירושלים', 'https://www.gov.il/he/service/apply_for_estates_committee'),
		('Igul Letova', 'Dorit Hassid', NULL,  DEFAULT, '036484775', 'dhassid@igul.org.il', N'סמ היסמין, 1, רמת גן, 5290701', 'https://www.round-up.org.il/'),
		('GALA Event', NULL, NULL, DEFAULT, NULL , NULL, NULL, NULL),
		('UK Online Giving Foundation', 'Ari Newman',' 2020-03-06' ,DEFAULT, '442039877578', 'arinewman@ukogf.org', N'c/o Womble Bond Dickinson (UK) LLP, 4 More London Riverside, London SE1 2AU', 'https://www.ukogf.org/'),
		('Pratt Foundation', 'Tamar Benbinisti', ' 2016-08-09', DEFAULT, '212 432-0070', 'tamarbenbinisti@verizon.net', N'406 Main Building 200 Willoughby Avenue Brooklyn, NY 11205', 'https://www.prattfoundation.org/'),
		('Rosa Luxemburg Foundation', 'Ifat Yanai', '2022-10-05', DEFAULT, '03 6228290', 'ifat.telaviv.office@rosalux.org', N'Rothschild Boulevard 11 Tel Aviv 6688114' , 'www.rosalux.org.il')
;

GO
