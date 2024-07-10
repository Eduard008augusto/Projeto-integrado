import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:soft_shares/database/server.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:collection';
import './database/var.dart' as globals;

class CalendarioEventos extends StatefulWidget {
  const CalendarioEventos({super.key});

  @override
  CalendarioEventosState createState() => CalendarioEventosState();
}

class CalendarioEventosState extends State<CalendarioEventos> {
  late final ValueNotifier<List<dynamic>> _selectedEvents;
  late final Map<DateTime, List<dynamic>> _events;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _selectedEvents = ValueNotifier([]);
    _events = LinkedHashMap<DateTime, List<dynamic>>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll({});
    _fetchAndSetEvents();
    initializeDateFormatting('pt_BR', null);  // Inicializa formatação de data em português
  }

  List<dynamic> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  void _fetchAndSetEvents() async {
    final eventos = await fetchEventos(globals.idCentro);
    setState(() {
      for (var evento in eventos) {
        DateTime eventDate = DateTime.parse(evento['DATA']);
        if (_events[eventDate] == null) {
          _events[eventDate] = [];
        }
        _events[eventDate]!.add(evento);
      }
      _selectedEvents.value = _getEventsForDay(_selectedDay);
    });
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendário de Eventos'),
      ),
      body: Column(
        children: [
          TableCalendar(
            locale: 'pt_BR',  // Define o idioma do calendário
            firstDay: DateTime.utc(2022, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: _onDaySelected,
            eventLoader: _getEventsForDay,
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Color.fromARGB(255, 57, 99, 156),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Color.fromARGB(131, 0, 183, 224),
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: Color.fromARGB(255, 0, 183, 224),
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,  // Oculta o botão de formato
              titleCentered: true,
            ),
            calendarBuilders: CalendarBuilders(
              dowBuilder: (context, day) {
                final text = DateFormat.E('pt_BR').format(day);
                return Center(
                  child: Text(
                    text,
                    style: const TextStyle(color: Colors.grey),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<dynamic>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    final event = value[index];
                    return ListTile(
                      leading: Image.network(
                        'https://pintbackend-w8pt.onrender.com/images/${event['IMAGEMEVENTO']}',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(event['NOME']),
                      subtitle: Text('Preço: ${event['PRECO']}€'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}
