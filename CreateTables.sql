-- Сначала удалим имеющиеся версии таблиц (начинаем с таблицы связей что бы не мешали ключи)
IF OBJECT_ID (N'CrossArtTag', N'U') IS NOT NULL
	DROP TABLE CrossArtTag;
IF OBJECT_ID (N'Article', N'U') IS NOT NULL
	DROP TABLE Article;
IF OBJECT_ID (N'Tag', N'U') IS NOT NULL
	DROP TABLE Tag;

-----------------------------------------------------------------------------------
-- Создаем таблицу статей
CREATE TABLE Article(
	id int NOT NULL,
	name nvarchar(50) NOT NULL,
 CONSTRAINT PK_Article_Id PRIMARY KEY CLUSTERED(id ASC)
	WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
-- Создаем уникальный индекс по имени статей (чтобы не заводили статьи с одинаковыми именами)
CREATE UNIQUE NONCLUSTERED INDEX IX_Article_Name ON Article(
	name ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

-----------------------------------------------------------------------------------
-- Создаем таблицу Тэгов
CREATE TABLE Tag(
	id int NOT NULL,
	name nvarchar(50) NOT NULL,
 CONSTRAINT PK_Tag_Id PRIMARY KEY CLUSTERED (id ASC)
	WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
-- Создаем уникальный индекс по имени тэга (чтобы не заводили тэги с одинаковыми именами)
CREATE UNIQUE NONCLUSTERED INDEX IX_Tag_Name ON Tag(
	name ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

-----------------------------------------------------------------------------------
-- Создаем таблицу перекрестных связей (многие-ко-многим) Статьи-Тэги
CREATE TABLE CrossArtTag(
	ArtId int NOT NULL,
	TagId int NOT NULL,
 CONSTRAINT PK_CrossArtTag PRIMARY KEY CLUSTERED (ArtId ASC, TagId ASC)
	WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
-- Создаем внешний ключ для статей
ALTER TABLE CrossArtTag WITH CHECK ADD CONSTRAINT FK_CrossArtTag_ArtId FOREIGN KEY(ArtId)
REFERENCES Article(id)
GO
-- Создаем внешний ключ для тэгов
ALTER TABLE CrossArtTag WITH CHECK ADD CONSTRAINT FK_CrossArtTag_TagId FOREIGN KEY(TagId)
REFERENCES Tag(id)
GO

-----------------------------------------------------------------------------------
-- Предположим у нас много однотипных таблиц и их надо заполнить 
-- Делаем универсальную процедуру для заполнения таких таблиц чтобы избежать копипасты
drop PROCEDURE FillTable
GO
CREATE PROCEDURE FillTable(@count int, @table nvarchar(30), @prefix nvarchar(30)) AS
BEGIN
	declare @sqlTxt nvarchar(MAX);
	set @sqlTxt = N'delete from ' + @table + '; ' +
		'DECLARE @Counter int;
		 SET @Counter = 1;
		 WHILE @Counter <= ' + Convert(nvarchar, @count) + ' BEGIN
			INSERT INTO ' + @table + '(id, name) 
				VALUES(@Counter, N''' + @prefix + ''' + Convert(nvarchar, @Counter));
			SET @Counter = @Counter + 1;
		 END;';
	exec (@sqlTxt);
END
GO

-- Заполняем таблицу статей
execute dbo.FillTable 4, N'Article', N'Art_';

-- Заполняем таблицу тэгов
execute dbo.FillTable 5, N'Tag', N'#Tag_';

-- Заполняем связи Статей и Тэгов
INSERT INTO CrossArtTag(ArtId, TagId) VALUES(1, 1);
INSERT INTO CrossArtTag(ArtId, TagId) VALUES(1, 2); 
INSERT INTO CrossArtTag(ArtId, TagId) VALUES(1, 3);
INSERT INTO CrossArtTag(ArtId, TagId) VALUES(2, 2);
INSERT INTO CrossArtTag(ArtId, TagId) VALUES(2, 3);
INSERT INTO CrossArtTag(ArtId, TagId) VALUES(3, 3);
INSERT INTO CrossArtTag(ArtId, TagId) VALUES(3, 4);

-- Все создано и
-- Теперь можно выполнять запросы из фала Task3.sql