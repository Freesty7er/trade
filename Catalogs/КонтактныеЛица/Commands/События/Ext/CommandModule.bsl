﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("КонтактноеЛицо", ПараметрКоманды);
	ПараметрыФормы.Вставить("Отбор", Новый Структура("Контрагент", ПараметрыВыполненияКоманды.Источник.Объект.Владелец));
	ОткрытьФорму("Документ.Событие.ФормаСписка", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры
