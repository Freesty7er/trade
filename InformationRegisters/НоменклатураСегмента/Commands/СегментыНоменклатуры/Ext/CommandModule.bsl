﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("Номенклатура", ПараметрКоманды);
	ОткрытьФорму(
		"РегистрСведений.НоменклатураСегмента.Форма.СегментыНоменлатурыПараметрическая",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно);

	
КонецПроцедуры
