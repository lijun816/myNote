USE [master]
GO

/****** Object:  Database [Publisher]    Script Date: 11/17/2013 08:27:15 AM ******/
CREATE DATABASE [Publisher]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Publisher', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\Publisher.mdf' , SIZE = 50MB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'Publisher_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\Publisher_log.ldf' , SIZE = 10MB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO

ALTER DATABASE [Publisher] SET COMPATIBILITY_LEVEL = 120
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Publisher].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO

ALTER DATABASE [Publisher] SET ANSI_NULL_DEFAULT OFF 
GO

ALTER DATABASE [Publisher] SET ANSI_NULLS OFF 
GO

ALTER DATABASE [Publisher] SET ANSI_PADDING OFF 
GO

ALTER DATABASE [Publisher] SET ANSI_WARNINGS OFF 
GO

ALTER DATABASE [Publisher] SET ARITHABORT OFF 
GO

ALTER DATABASE [Publisher] SET AUTO_CLOSE OFF 
GO

ALTER DATABASE [Publisher] SET AUTO_CREATE_STATISTICS ON 
GO

ALTER DATABASE [Publisher] SET AUTO_SHRINK OFF 
GO

ALTER DATABASE [Publisher] SET AUTO_UPDATE_STATISTICS ON 
GO

ALTER DATABASE [Publisher] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO

ALTER DATABASE [Publisher] SET CURSOR_DEFAULT  GLOBAL 
GO

ALTER DATABASE [Publisher] SET CONCAT_NULL_YIELDS_NULL OFF 
GO

ALTER DATABASE [Publisher] SET NUMERIC_ROUNDABORT OFF 
GO

ALTER DATABASE [Publisher] SET QUOTED_IDENTIFIER OFF 
GO

ALTER DATABASE [Publisher] SET RECURSIVE_TRIGGERS OFF 
GO

ALTER DATABASE [Publisher] SET  DISABLE_BROKER 
GO

ALTER DATABASE [Publisher] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO

ALTER DATABASE [Publisher] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO

ALTER DATABASE [Publisher] SET TRUSTWORTHY OFF 
GO

ALTER DATABASE [Publisher] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO

ALTER DATABASE [Publisher] SET PARAMETERIZATION SIMPLE 
GO

ALTER DATABASE [Publisher] SET READ_COMMITTED_SNAPSHOT OFF 
GO

ALTER DATABASE [Publisher] SET HONOR_BROKER_PRIORITY OFF 
GO

ALTER DATABASE [Publisher] SET  READ_WRITE 
GO

ALTER DATABASE [Publisher] SET RECOVERY FULL 
GO

ALTER DATABASE [Publisher] SET  MULTI_USER 
GO

ALTER DATABASE [Publisher] SET PAGE_VERIFY CHECKSUM  
GO

ALTER DATABASE [Publisher] SET DB_CHAINING OFF 
GO


USE [master]
GO

/****** Object:  Database [Subscriber]    Script Date: 11/17/2013 08:27:15 AM ******/
CREATE DATABASE [Subscriber]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Subscriber', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\Subscriber.mdf' , SIZE = 50MB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'Subscriber_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\Subscriber_log.ldf' , SIZE = 10MB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO

ALTER DATABASE [Subscriber] SET COMPATIBILITY_LEVEL = 120
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Subscriber].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO

ALTER DATABASE [Subscriber] SET ANSI_NULL_DEFAULT OFF 
GO

ALTER DATABASE [Subscriber] SET ANSI_NULLS OFF 
GO

ALTER DATABASE [Subscriber] SET ANSI_PADDING OFF 
GO

ALTER DATABASE [Subscriber] SET ANSI_WARNINGS OFF 
GO

ALTER DATABASE [Subscriber] SET ARITHABORT OFF 
GO

ALTER DATABASE [Subscriber] SET AUTO_CLOSE OFF 
GO

ALTER DATABASE [Subscriber] SET AUTO_CREATE_STATISTICS ON 
GO

ALTER DATABASE [Subscriber] SET AUTO_SHRINK OFF 
GO

ALTER DATABASE [Subscriber] SET AUTO_UPDATE_STATISTICS ON 
GO

ALTER DATABASE [Subscriber] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO

ALTER DATABASE [Subscriber] SET CURSOR_DEFAULT  GLOBAL 
GO

ALTER DATABASE [Subscriber] SET CONCAT_NULL_YIELDS_NULL OFF 
GO

ALTER DATABASE [Subscriber] SET NUMERIC_ROUNDABORT OFF 
GO

ALTER DATABASE [Subscriber] SET QUOTED_IDENTIFIER OFF 
GO

ALTER DATABASE [Subscriber] SET RECURSIVE_TRIGGERS OFF 
GO

ALTER DATABASE [Subscriber] SET  DISABLE_BROKER 
GO

ALTER DATABASE [Subscriber] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO

ALTER DATABASE [Subscriber] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO

ALTER DATABASE [Subscriber] SET TRUSTWORTHY OFF 
GO

ALTER DATABASE [Subscriber] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO

ALTER DATABASE [Subscriber] SET PARAMETERIZATION SIMPLE 
GO

ALTER DATABASE [Subscriber] SET READ_COMMITTED_SNAPSHOT OFF 
GO

ALTER DATABASE [Subscriber] SET HONOR_BROKER_PRIORITY OFF 
GO

ALTER DATABASE [Subscriber] SET  READ_WRITE 
GO

ALTER DATABASE [Subscriber] SET RECOVERY FULL 
GO

ALTER DATABASE [Subscriber] SET  MULTI_USER 
GO

ALTER DATABASE [Subscriber] SET PAGE_VERIFY CHECKSUM  
GO

ALTER DATABASE [Subscriber] SET DB_CHAINING OFF 
GO

USE [master]
GO

/****** Object:  Database [Distribution]    Script Date: 11/18/2013 8:59:10 AM ******/
CREATE DATABASE [Distribution]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Distribution', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\Distribution.mdf' , SIZE = 10240KB , MAXSIZE = 102400KB , FILEGROWTH = 10%)
 LOG ON 
( NAME = N'Distribution_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\Distribution_log.ldf' , SIZE = 5120KB , MAXSIZE = 51200KB , FILEGROWTH = 10%)
GO

ALTER DATABASE [Distribution] SET COMPATIBILITY_LEVEL = 120
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Distribution].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO

ALTER DATABASE [Distribution] SET ANSI_NULL_DEFAULT OFF 
GO

ALTER DATABASE [Distribution] SET ANSI_NULLS OFF 
GO

ALTER DATABASE [Distribution] SET ANSI_PADDING OFF 
GO

ALTER DATABASE [Distribution] SET ANSI_WARNINGS OFF 
GO

ALTER DATABASE [Distribution] SET ARITHABORT OFF 
GO

ALTER DATABASE [Distribution] SET AUTO_CLOSE OFF 
GO

ALTER DATABASE [Distribution] SET AUTO_CREATE_STATISTICS ON 
GO

ALTER DATABASE [Distribution] SET AUTO_SHRINK OFF 
GO

ALTER DATABASE [Distribution] SET AUTO_UPDATE_STATISTICS ON 
GO

ALTER DATABASE [Distribution] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO

ALTER DATABASE [Distribution] SET CURSOR_DEFAULT  GLOBAL 
GO

ALTER DATABASE [Distribution] SET CONCAT_NULL_YIELDS_NULL OFF 
GO

ALTER DATABASE [Distribution] SET NUMERIC_ROUNDABORT OFF 
GO

ALTER DATABASE [Distribution] SET QUOTED_IDENTIFIER OFF 
GO

ALTER DATABASE [Distribution] SET RECURSIVE_TRIGGERS OFF 
GO

ALTER DATABASE [Distribution] SET  DISABLE_BROKER 
GO

ALTER DATABASE [Distribution] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO

ALTER DATABASE [Distribution] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO

ALTER DATABASE [Distribution] SET TRUSTWORTHY OFF 
GO

ALTER DATABASE [Distribution] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO

ALTER DATABASE [Distribution] SET PARAMETERIZATION SIMPLE 
GO

ALTER DATABASE [Distribution] SET READ_COMMITTED_SNAPSHOT OFF 
GO

ALTER DATABASE [Distribution] SET HONOR_BROKER_PRIORITY OFF 
GO

ALTER DATABASE [Distribution] SET RECOVERY FULL 
GO

ALTER DATABASE [Distribution] SET  MULTI_USER 
GO

ALTER DATABASE [Distribution] SET PAGE_VERIFY CHECKSUM  
GO

ALTER DATABASE [Distribution] SET DB_CHAINING OFF 
GO

ALTER DATABASE [Distribution] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO

ALTER DATABASE [Distribution] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO

ALTER DATABASE [Distribution] SET DELAYED_DURABILITY = DISABLED 
GO

ALTER DATABASE [Distribution] SET  READ_WRITE 
GO


