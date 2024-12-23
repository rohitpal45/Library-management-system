USE [master]
GO
/****** Object:  Database [DB_LibraryMS]    Script Date: 21/12/2024 13:57:51 ******/
CREATE DATABASE [DB_LibraryMS]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'DB_LibraryMS', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\DB_LibraryMS.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'DB_LibraryMS_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\DB_LibraryMS_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [DB_LibraryMS] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [DB_LibraryMS].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [DB_LibraryMS] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [DB_LibraryMS] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [DB_LibraryMS] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [DB_LibraryMS] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [DB_LibraryMS] SET ARITHABORT OFF 
GO
ALTER DATABASE [DB_LibraryMS] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [DB_LibraryMS] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [DB_LibraryMS] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [DB_LibraryMS] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [DB_LibraryMS] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [DB_LibraryMS] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [DB_LibraryMS] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [DB_LibraryMS] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [DB_LibraryMS] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [DB_LibraryMS] SET  ENABLE_BROKER 
GO
ALTER DATABASE [DB_LibraryMS] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [DB_LibraryMS] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [DB_LibraryMS] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [DB_LibraryMS] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [DB_LibraryMS] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [DB_LibraryMS] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [DB_LibraryMS] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [DB_LibraryMS] SET RECOVERY FULL 
GO
ALTER DATABASE [DB_LibraryMS] SET  MULTI_USER 
GO
ALTER DATABASE [DB_LibraryMS] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [DB_LibraryMS] SET DB_CHAINING OFF 
GO
ALTER DATABASE [DB_LibraryMS] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [DB_LibraryMS] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [DB_LibraryMS] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [DB_LibraryMS] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'DB_LibraryMS', N'ON'
GO
ALTER DATABASE [DB_LibraryMS] SET QUERY_STORE = ON
GO
ALTER DATABASE [DB_LibraryMS] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200)
GO
USE [DB_LibraryMS]
GO
/****** Object:  Table [dbo].[tblBooks]    Script Date: 21/12/2024 13:57:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblBooks](
	[BookId] [int] IDENTITY(1,1) NOT NULL,
	[BookTitle] [nvarchar](100) NULL,
	[BookCategory] [nvarchar](100) NULL,
	[BookAuthor] [nvarchar](100) NULL,
	[BookCopies] [int] NULL,
	[BookPub] [nvarchar](100) NULL,
	[BookPubName] [nvarchar](100) NULL,
	[BookISBN] [nvarchar](100) NULL,
	[Copyright] [int] NULL,
	[DateAdded] [nvarchar](100) NULL,
	[Status] [nvarchar](100) NULL,
	[penaltyCharge] [int] NOT NULL,
	[ReturnDaysLimit] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[BookId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblTransactions]    Script Date: 21/12/2024 13:57:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblTransactions](
	[TranId] [int] IDENTITY(1,1) NOT NULL,
	[BookId] [int] NULL,
	[BookTitle] [nvarchar](100) NULL,
	[BookISBN] [nvarchar](100) NULL,
	[TranStatus] [nvarchar](100) NULL,
	[TranDate] [nvarchar](100) NULL,
	[UserId] [int] NULL,
	[UserName] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[TranId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[AddExtraChage]    Script Date: 21/12/2024 13:57:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View   [dbo].[AddExtraChage]
as 
SELECT 
    b.BookTitle,
    b.BookISBN,
    b.BookCategory,
    b.BookAuthor,
    b.BookPubName,
  case when  (DATEDIFF(DAY, GETDATE(),CONVERT(DATE, TranDate, 103))-ReturnDaysLimit)<=0 then 0
  else (DATEDIFF(DAY, GETDATE(),CONVERT(DATE, TranDate, 103))-ReturnDaysLimit) * penaltyCharge  end  
  
  AS DayMultiplier,
    t.TranDate,t.TranId,t.TranStatus,UserId
FROM 
    tblTransactions t
JOIN 
    tblBooks b ON b.BookId = t.BookId--WHERE 
  --  DATEDIFF(DAY, CONVERT(DATE, TranDate, 103), GETDATE()) > 0;

--Select * from  tblTransactions
--Update  tblTransactions set TranDate='20/12/2024'
GO
/****** Object:  Table [dbo].[tblAdmin]    Script Date: 21/12/2024 13:57:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblAdmin](
	[AdminId] [int] IDENTITY(1,1) NOT NULL,
	[AdminName] [nvarchar](100) NULL,
	[AdminEmail] [nvarchar](100) NULL,
	[AdminPass] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[AdminId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblUsers]    Script Date: 21/12/2024 13:57:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblUsers](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](100) NULL,
	[UserGender] [nvarchar](100) NULL,
	[UserDep] [nvarchar](100) NULL,
	[UserAdmNo] [int] NULL,
	[UserEmail] [nvarchar](100) NULL,
	[UserPass] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[tblAdmin] ON 

INSERT [dbo].[tblAdmin] ([AdminId], [AdminName], [AdminEmail], [AdminPass]) VALUES (1, N'Admin', N'Admin@gmail.com', N'123456')
SET IDENTITY_INSERT [dbo].[tblAdmin] OFF
GO
SET IDENTITY_INSERT [dbo].[tblBooks] ON 

INSERT [dbo].[tblBooks] ([BookId], [BookTitle], [BookCategory], [BookAuthor], [BookCopies], [BookPub], [BookPubName], [BookISBN], [Copyright], [DateAdded], [Status], [penaltyCharge], [ReturnDaysLimit]) VALUES (1, N'Half Girlfriend', N'Romance', N'Chetan Bhagat', 11, N'Romance novel', N'Romance novel', N'0-45-6', 1998, N'12/01/2024', N'New', 10, 2)
SET IDENTITY_INSERT [dbo].[tblBooks] OFF
GO
SET IDENTITY_INSERT [dbo].[tblTransactions] ON 

INSERT [dbo].[tblTransactions] ([TranId], [BookId], [BookTitle], [BookISBN], [TranStatus], [TranDate], [UserId], [UserName]) VALUES (1, 1, N'Half Girlfriend', N'0-45-6', N'Accepted', N'20/12/2024', 1, N'Vaibhav')
SET IDENTITY_INSERT [dbo].[tblTransactions] OFF
GO
SET IDENTITY_INSERT [dbo].[tblUsers] ON 

INSERT [dbo].[tblUsers] ([UserId], [UserName], [UserGender], [UserDep], [UserAdmNo], [UserEmail], [UserPass]) VALUES (1, N'Rohit', N'Male', N'Mech', 1231, N'Rohit@gmail.com', N'123456')
SET IDENTITY_INSERT [dbo].[tblUsers] OFF
GO
ALTER TABLE [dbo].[tblBooks] ADD  DEFAULT ((0)) FOR [penaltyCharge]
GO
ALTER TABLE [dbo].[tblBooks] ADD  DEFAULT ((0)) FOR [ReturnDaysLimit]
GO
/****** Object:  StoredProcedure [dbo].[Sp_AddExtraChage]    Script Date: 21/12/2024 13:57:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[Sp_AddExtraChage]
as 
SELECT 
    b.BookTitle,
    b.BookISBN,
    b.BookCategory,
    b.BookAuthor,
    b.BookPubName,
    DATEDIFF(DAY, CONVERT(DATE, TranDate, 103), GETDATE()) * 10 AS DayMultiplier,
    t.*
FROM 
    tblTransactions t
JOIN 
    tblBooks b ON b.BookId = t.BookId
WHERE 
    DATEDIFF(DAY, CONVERT(DATE, TranDate, 103), GETDATE()) > 0;
GO
USE [master]
GO
ALTER DATABASE [DB_LibraryMS] SET  READ_WRITE 
GO
