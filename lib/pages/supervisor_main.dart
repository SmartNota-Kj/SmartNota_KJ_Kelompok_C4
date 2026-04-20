import 'package:flutter/material.dart';
import '../themes/app_theme.dart';
import 'supervisor_dashboard.dart';
import 'nota_list_page.dart';
import 'rekap_page.dart';
import 'user_management_page.dart';

class SupervisorMain extends StatefulWidget {
  const SupervisorMain({super.key});

  @override
  State<SupervisorMain> createState() => _SupervisorMainState();
}

class _SupervisorMainState extends State<SupervisorMain> {
  int _index = 0;

  final _pages = const [
    SupervisorDashboard(),
    NotaListPage(),
    RekapPage(),
    UserManagementPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppTheme.border)),
        ),
        child: BottomNavigationBar(
          currentIndex: _index,
          onTap: (i) => setState(() => _index = i),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard_rounded),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              activeIcon: Icon(Icons.receipt_long_rounded),
              label: 'Nota',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined),
              activeIcon: Icon(Icons.bar_chart_rounded),
              label: 'Rekap',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outlined),
              activeIcon: Icon(Icons.people_rounded),
              label: 'Pengguna',
            ),
          ],
        ),
      ),
    );
  }
}
