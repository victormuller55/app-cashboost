import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:app_cashback_soamer/app_widget/app_consts/app_colors.dart' as cashboost;
import 'package:app_cashback_soamer/models/vendedor_model.dart';
import 'package:app_cashback_soamer/telas/home/extrato/extrato_screen.dart';
import 'package:app_cashback_soamer/telas/home/inicio/inicio_screen.dart';
import 'package:app_cashback_soamer/telas/home/perfil/perfil_screen.dart';
import 'package:app_cashback_soamer/telas/home/recompensas/recompensas_screen.dart';
import 'package:app_cashback_soamer/telas/registrar_venda/registrar_venda_screen.dart';
import 'package:flutter/material.dart';
import 'package:muller_package/muller_package.dart';

class HomeScreen extends StatefulWidget {

  final VendedorModel vendedorModel;
  const HomeScreen({super.key, required this.vendedorModel});

  @override
  State<HomeScreen> createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {

  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = [];

  @override
  void initState() {
    _widgetOptions = <Widget>[
      const InicioScreen(),
      const RecompensasScreen(),
      const ExtratoScreen(),
      const PerfilScreen(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: AnimatedBottomNavigationBar(
        height: 60,
        icons: const [
          Icons.home,
          Icons.card_giftcard,
          Icons.history,
          Icons.person,
        ],
        activeIndex: _selectedIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.defaultEdge,
        onTap: (index) => setState(() => _selectedIndex = index),
        backgroundColor: cashboost.AppColors.primaryColor,
        iconSize: 30,
        notchMargin: 5,
        splashSpeedInMilliseconds: 0,
        gapWidth: 100,
        activeColor: Colors.white,
        inactiveColor: Colors.grey.shade300,
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        height: 70,
        width: 70,
        child: FittedBox(
          child: FloatingActionButton(
            heroTag: "floatingButton",
            onPressed: () => open( screen: const RegistrarVendaScreen()),
            backgroundColor: cashboost.AppColors.secondaryColor,
            child: const Icon(Icons.camera_alt, size: 30),
          ),
        ),
      ),
    );
  }
}
