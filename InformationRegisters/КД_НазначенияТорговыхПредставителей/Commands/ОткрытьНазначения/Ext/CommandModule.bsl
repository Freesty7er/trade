﻿
&НаКлиенте
Процедура ОбработкаКоманды(параметрКоманды, параметрыВыполненияКоманды)
	
	отбор = Новый Структура("Менеджер", параметрКоманды);
	параметрыФормы = Новый Структура("Отбор", отбор);
	ОткрытьФорму("РегистрСведений.КД_НазначенияТорговыхПредставителей.Форма.ФормаПросмотраНазначений", параметрыФормы, параметрыВыполненияКоманды.Источник, параметрыВыполненияКоманды.Уникальность, параметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры
