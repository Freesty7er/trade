﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	отбор = Новый Структура("Автомобиль", параметрКоманды);
	параметрыФормы = Новый Структура("Отбор", отбор);
	ОткрытьФорму("Документ.РемонтыАвтомобилей.Форма.ФормаПросмотраРемонтов", параметрыФормы, параметрыВыполненияКоманды.Источник, параметрыВыполненияКоманды.Уникальность, параметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);

КонецПроцедуры
