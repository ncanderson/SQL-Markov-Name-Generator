﻿use Name_Generator

begin transaction 

insert into [dbo].[RAW_character_Dictionary] 
values
('<A/>',N'Ā'),
('<a/>',N'ā'),
('<Â>',N'Â'), 
('<â>',N'â'),
('<A,>',N'Ą'),
('<a,>',N'ą'),
('<C´>',N'Ć'),
('<c´>',N'ć'),
('<C^>',N'Č'),
('<CH>',N'Č'),
('<c^>',N'č'),
('<ch>',N'č'),
('<d´>',N'ď'),
('<Ð>',N'Đ'),
('<DJ>',N'Đ'),
('<ð>',N'ð'),
('<dj>',N'đ'),
('<E/>',N'Ē'),
('<e/>',N'ē'),
('<E°>',N'Ė'),
('<e°>',N'ė'),
('<E,>',N'Ę'),
('<e,>',N'ę'),
('<Ê>',N'Ě'),
('<ê>',N'ě'),
('<G^>',N'Ğ'),
('<g^>',N'ğ'),
('<G,>',N'Ģ'),
('<g´>',N'ģ'),
('<I/>',N'Ī'),
('<i/>',N'ī'),
('<I°>',N'İ'),
('<I,>',N'Į'),
('<i>',N'i'),
('<IJ>',N'IJ'),
('<ij>',N'ij'),
('<K,>',N'Ķ'),
('<k,>',N'ķ'),
('<L,>',N'Ļ'),
('<l,>',N'ļ'),
('<L´>',N'Ľ'),
('<l´>',N'ľ'),
('<L/>',N'Ł'),
('<l/>',N'ł'),
('<N,>',N'Ņ'),
('<n,>',N'ņ'),
('<N^>',N'Ň'),
('<n^>',N'ň'),
('<Ö>',N'Ö'),
('<ö>',N'ö'),
('<OE>',N'Œ'),
('<oe>',N'œ'),
('<R^>',N'Ř'),
('<r^>',N'ř'),
('<S,>',N'Ș'),
('<s,>',N'ş'),
('<Š>',N'Š'),
('<S^>',N'Š'),
('<SCH>',N'Š'),
('<SH>',N'Š'),
('<š>',N'š'),
('<s^>',N'š'),
('<sch>',N'š'),
('<sh>',N'š'),
('<T,>',N'Ț'),
('<t,>',N'ț'),
('<t´>',N'ť'),
('<U/>',N'Ū'),
('<u/>',N'ū'),
('<U°>',N'Ů'),
('<u°>',N'ů'),
('<U,>',N'Ų'),
('<u,>',N'ų'),
('<Z°>',N'Ż'),
('<z°>',N'ż'),
('<Z^>',N'Ž'),
('<z^>',N'ž')


commit transaction