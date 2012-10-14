---------------------------------------------------------------------------
--
-- setup_exp_tables.sql
--
---------------------------------------------------------------------------
-- www.QuestorSystems.com              -:-     developer@QuestorSystems.com
---------------------------------------------------------------------------
--
-- setup_exp_tables.sql: whatever
--
-- Project:	
-- Author:	Farley Balasuriya (developer@QuestorSystems.com)
-- Created:	2008-11-24T11:10:31
-- History:
--		v0.2 - 
--		v0.1 - 2008-11-24 - initial version created
--            
---------------------------------------------------------------------------
DECLARE @svn_rev varchar(100), @svn_id varchar(100), @svn_LastChangedDate varchar(255)
SET @svn_rev='$Rev: 110 $'
SET @svn_id='$Id: tapp.pl 110 2005-04-25 02:40:51Z farley $'
SET @svn_LastChangedDate='$LastChangedDate: 2005-04-25 04:40:51 +0200 (Mon, 25 Apr 2005) $'
---------------------------------------------------------------------------
-- (c) 1997 - 2008, QuestorSystems.com, All rights reserved.
-- Gempenstrasse 46, CH-4053, Basel, Switzerland
-- telephone:+41 79 285 6482,  email:developer@QuestorSystems.com
---------------------------------------------------------------------------



/*
 * SQL script
 */


USE [QBase]
GO


-- DDL


/****** Object:  Table [dbo].[ExpenseItems]    Script Date: 11/24/2008 09:06:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[expense_items](
	[expense_id] [int] IDENTITY(1,1) NOT NULL,
	[value_date] [datetime] NOT NULL DEFAULT (getdate()),
	[category] [char](6) NOT NULL DEFAULT ('SUB'),
	[amount] [decimal](9, 2) NOT NULL,
	[currency_code] [char](3) NOT NULL DEFAULT ('CHF'),
	[amount_CHF] [decimal](9, 2) ,
	[description] [varchar](50) NULL,
	[post_date] [datetime] NOT NULL DEFAULT (getdate()),
	[booked_date] [datetime] NULL ),
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[expense_items]  WITH CHECK ADD  CONSTRAINT [Category__FK__ExpenseCategories4] FOREIGN KEY([category])
REFERENCES [dbo].[ExpenseCategories] ([Category])
GO
ALTER TABLE [dbo].[expense_items] CHECK CONSTRAINT [Category__FK__ExpenseCategories4]
GO
ALTER TABLE [dbo].[expense_items]  WITH CHECK ADD  CONSTRAINT [Currency__FK__ISOCurrencies4] FOREIGN KEY([currency_code])
REFERENCES [dbo].[ISOCurrencies] ([CurrencyCode])
GO
ALTER TABLE [dbo].[expense_items] CHECK CONSTRAINT [Currency__FK__ISOCurrencies4]




create table dbo.expense_claims
(
claim_id integer not null identity(1,1),
claim_date datetime not null default(GETDATE()),
amount_CHF decimal(9,2) not null,
payment_date datetime NULL
)




-- DML




---------------------------------------------------------------------------
-- setup_exp_tables.sql            -:-     developer@QuestorSystems.com
---------------------------------------------------------------------------

