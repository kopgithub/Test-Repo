-- ������� ������ ����� ��� ������ ������
select a.name, t.name
from Article a
	left join CrossArtTag c on c.ArtId = a.id
	left join Tag t on t.id = c.TagId;

-- ������� ������ ������ ��� ������� ����
select t.name, a.name
from Tag t
	left join CrossArtTag c on c.TagId = t.id
	left join Article a on a.id = c.ArtId;

-- ������� ���� ������ ��������� ������ � �����
select a.name, t.name
from Article a
	left join CrossArtTag c on c.ArtId = a.id
	full join Tag t on t.id = c.TagId;

-- ������� ���-�� ����� ��� ������ ������
select a.name, count(t.id) as tagsCount
from Article a
	left join CrossArtTag c on c.ArtId = a.id
	left join Tag t on t.id = c.TagId
group by a.id, a.name

-- ������� ���-�� ����� ��� ������ ������ (� ������� ���� ����)
select a.name, count(t.id) as tagsCount
	from Article a
	left join CrossArtTag c on c.ArtId = a.id
	left join Tag t on t.id = c.TagId
group by a.id, a.name
having count(t.id) > 0
order by count(t.id) desc;
-- ���
select a.name, count(*) as tagsCount
from Article a
	inner join CrossArtTag c on c.ArtId = a.id
	inner join Tag t on t.id = c.TagId
group by a.id, a.name
order by count(*) desc;

-- ������� ��� ������ � ������� ��� �����,
-- �������� 3� ������� �� �����, ���������� ���������, ��� ��� ������
select a.name
from Article a
	left join CrossArtTag c on c.ArtId = a.id
where c.TagId is null;
