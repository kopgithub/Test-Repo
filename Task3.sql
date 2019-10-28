-- Выводим список тэгов для каждой статьи
select a.name, t.name
from Article a
	left join CrossArtTag c on c.ArtId = a.id
	left join Tag t on t.id = c.TagId;

-- Выводим список статей для кажгого тэга
select t.name, a.name
from Tag t
	left join CrossArtTag c on c.TagId = t.id
	left join Article a on a.id = c.ArtId;

-- Выводим весь список отношений статей и тэгов
select a.name, t.name
from Article a
	left join CrossArtTag c on c.ArtId = a.id
	full join Tag t on t.id = c.TagId;

-- Выводим кол-во тэгов для каждой статьи
select a.name, count(t.id) as tagsCount
from Article a
	left join CrossArtTag c on c.ArtId = a.id
	left join Tag t on t.id = c.TagId
group by a.id, a.name

-- Выводим кол-во тэгов для каждой статьи (у которой ЕСТЬ тэги)
select a.name, count(t.id) as tagsCount
	from Article a
	left join CrossArtTag c on c.ArtId = a.id
	left join Tag t on t.id = c.TagId
group by a.id, a.name
having count(t.id) > 0
order by count(t.id) desc;
-- ИЛИ
select a.name, count(*) as tagsCount
from Article a
	inner join CrossArtTag c on c.ArtId = a.id
	inner join Tag t on t.id = c.TagId
group by a.id, a.name
order by count(*) desc;

-- Выводим все статьи у которых нет тэгов,
-- джойнить 3ю таблицу не нужно, достаточно убедиться, что нет связей
select a.name
from Article a
	left join CrossArtTag c on c.ArtId = a.id
where c.TagId is null;
