
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const StockApp());
}

// ==================== APP ====================

const primaryColor = Color(0xFF4F46E5);
const darkColor = Color(0xFF111827);
const backgroundColor = Color(0xFFF5F7FB);

class StockApp extends StatelessWidget {
  const StockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stock',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: backgroundColor,
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        fontFamily: 'Roboto',
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF8FAFC),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: primaryColor),
          ),
        ),
      ),
      home: const AuthGate(),
    );
  }
}

// ==================== AUTHENTICATION GATE ====================

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool isLoggedIn = false;
  String currentUser = '';

  void login(String email) {
    setState(() {
      isLoggedIn = true;
      currentUser = email;
    });
  }

  void logout() {
    setState(() {
      isLoggedIn = false;
      currentUser = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoggedIn) {
      return LoginPage(onLogin: login);
    }

    return StockDashboard(
      userEmail: currentUser,
      onLogout: logout,
    );
  }
}

// ==================== LOGIN PAGE ====================

class LoginPage extends StatefulWidget {
  final ValueChanged<String> onLogin;

  const LoginPage({super.key, required this.onLogin});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool passwordVisible = false;
  bool loading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> signIn() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => loading = true);

    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    // DEMO ONLY. Replace with real backend authentication.
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.toLowerCase() == 'stock@demo.com' &&
        password == 'Stock123!') {
      widget.onLogin(email);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Invalid credentials. Check the demo login details.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }

    if (mounted) setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          if (MediaQuery.sizeOf(context).width >= 800)
            Expanded(
              child: Container(
                color: darkColor,
                padding: const EdgeInsets.all(48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.inventory_2_rounded,
                      color: Colors.white,
                      size: 64,
                    ),
                    const SizedBox(height: 28),
                    const Text(
                      'Stock.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 44,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Inventory management,\nsimplified.',
                      style: TextStyle(
                        color: Color(0xFFCBD5E1),
                        fontSize: 26,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Manage products, monitor stock levels, '
                      'and track every movement from one place.',
                      style: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 16,
                        height: 1.8,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (MediaQuery.sizeOf(context).width < 800) ...[
                          const Icon(
                            Icons.inventory_2_rounded,
                            size: 58,
                            color: primaryColor,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Stock.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 32),
                        ],
                        const Text(
                          'Welcome back',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: darkColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Sign in to access your inventory dashboard.',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 32),
                        const Text(
                          'Email address',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: 'Enter your email',
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Email is required';
                            }
                            if (!RegExp(
                              r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                            ).hasMatch(value.trim())) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Password',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: passwordController,
                          obscureText: !passwordVisible,
                          decoration: InputDecoration(
                            hintText: 'Enter your password',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  passwordVisible = !passwordVisible;
                                });
                              },
                              icon: Icon(
                                passwordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password is required';
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) => signIn(),
                        ),
                        const SizedBox(height: 28),
                        SizedBox(
                          height: 52,
                          child: FilledButton(
                            onPressed: loading ? null : signIn,
                            style: FilledButton.styleFrom(
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: loading
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Sign In',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEF2FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Demo credentials',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              SelectableText('Email: stock@demo.com'),
                              SizedBox(height: 4),
                              SelectableText('Password: Stock123!'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Stock Inventory Management System',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== PRODUCT MODEL ====================

class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  int quantity;
  final int minimumStock;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.quantity,
    required this.minimumStock,
  });

  bool get isLowStock => quantity <= minimumStock;
}

class StockMovement {
  final String productName;
  final String type;
  final int quantity;
  final DateTime date;
  final String note;

  StockMovement({
    required this.productName,
    required this.type,
    required this.quantity,
    required this.date,
    required this.note,
  });
}

// ==================== DASHBOARD ====================

class StockDashboard extends StatefulWidget {
  final String userEmail;
  final VoidCallback onLogout;

  const StockDashboard({
    super.key,
    required this.userEmail,
    required this.onLogout,
  });

  @override
  State<StockDashboard> createState() => _StockDashboardState();
}

class _StockDashboardState extends State<StockDashboard> {
  int selectedPage = 0;
  String searchQuery = '';

  final searchController = TextEditingController();

  final List<Product> products = [
    Product(
      id: 'PRD-001',
      name: 'Wireless Mouse',
      category: 'Electronics',
      price: 15000,
      quantity: 45,
      minimumStock: 10,
    ),
    Product(
      id: 'PRD-002',
      name: 'USB Keyboard',
      category: 'Electronics',
      price: 22000,
      quantity: 8,
      minimumStock: 10,
    ),
    Product(
      id: 'PRD-003',
      name: 'A4 Paper Pack',
      category: 'Stationery',
      price: 6000,
      quantity: 120,
      minimumStock: 20,
    ),
    Product(
      id: 'PRD-004',
      name: 'Office Chair',
      category: 'Furniture',
      price: 95000,
      quantity: 4,
      minimumStock: 5,
    ),
  ];

  final List<StockMovement> movements = [];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  String money(double value) {
    return '${value.toStringAsFixed(0)} RWF';
  }

  int get totalUnits =>
      products.fold(0, (sum, product) => sum + product.quantity);

  double get inventoryValue => products.fold(
        0,
        (sum, product) => sum + product.price * product.quantity,
      );

  int get lowStockCount =>
      products.where((product) => product.isLowStock).length;

  List<Product> get filteredProducts {
    final query = searchQuery.toLowerCase();

    return products.where((product) {
      return product.name.toLowerCase().contains(query) ||
          product.id.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query);
    }).toList();
  }

  void notify(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> addProduct() async {
    final result = await showDialog<Product>(
      context: context,
      builder: (_) => const ProductDialog(),
    );

    if (result == null || !mounted) return;

    final duplicate = products.any(
      (product) => product.id.toLowerCase() == result.id.toLowerCase(),
    );

    if (duplicate) {
      notify('That product ID already exists.');
      return;
    }

    setState(() {
      products.insert(0, result);

      if (result.quantity > 0) {
        movements.insert(
          0,
          StockMovement(
            productName: result.name,
            type: 'IN',
            quantity: result.quantity,
            date: DateTime.now(),
            note: 'Initial stock',
          ),
        );
      }
    });

    notify('Product added successfully.');
  }

  Future<void> moveStock(bool isStockIn) async {
    if (products.isEmpty) {
      notify('Add a product before recording stock movements.');
      return;
    }

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => MovementDialog(
        products: products,
        isStockIn: isStockIn,
      ),
    );

    if (result == null || !mounted) return;

    final product = result['product'] as Product;
    final quantity = result['quantity'] as int;
    final note = result['note'] as String;

    if (!isStockIn && quantity > product.quantity) {
      notify('Not enough stock available.');
      return;
    }

    setState(() {
      if (isStockIn) {
        product.quantity += quantity;
      } else {
        product.quantity -= quantity;
      }

      movements.insert(
        0,
        StockMovement(
          productName: product.name,
          type: isStockIn ? 'IN' : 'OUT',
          quantity: quantity,
          date: DateTime.now(),
          note: note.isEmpty
              ? (isStockIn ? 'Stock received' : 'Stock issued')
              : note,
        ),
      );
    });

    notify(
      isStockIn
          ? 'Stock received successfully.'
          : 'Stock issued successfully.',
    );
  }

  void openPage(int index) {
    setState(() {
      selectedPage = index;
      searchQuery = '';
      searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 900;

    final titles = [
      'Overview',
      'Products',
      'Stock In',
      'Stock Out',
      'Transactions',
      'Low Stock',
    ];

    return Scaffold(
      drawer: wide
          ? null
          : Drawer(
              child: SafeArea(
                child: _sidebarContent(),
              ),
            ),
      body: Row(
        children: [
          if (wide)
            SizedBox(
              width: 245,
              child: _sidebarContent(),
            ),
          Expanded(
            child: Column(
              children: [
                _topBar(titles[selectedPage], wide),
                Expanded(
                  child: _pageContent(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sidebarContent() {
    return Container(
      color: darkColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 16, 28),
            child: Row(
              children: [
                const Icon(
                  Icons.inventory_2_rounded,
                  color: Colors.white,
                  size: 34,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Stock.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(24, 0, 0, 12),
            child: Text(
              'WORKSPACE',
              style: TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 11,
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _navItem(0, Icons.grid_view_rounded, 'Overview'),
          _navItem(1, Icons.inventory_2_outlined, 'Products'),
          _navItem(2, Icons.add_box_outlined, 'Stock In'),
          _navItem(3, Icons.outbox_outlined, 'Stock Out'),
          _navItem(4, Icons.receipt_long_outlined, 'Transactions'),
          _navItem(5, Icons.warning_amber_rounded, 'Low Stock'),
          const Spacer(),
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1F2937),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.account_circle_outlined,
                  color: Colors.white,
                  size: 30,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Signed in as',
                  style: TextStyle(color: Color(0xFF9CA3AF)),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.userEmail,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: widget.onLogout,
                    icon: const Icon(Icons.logout, size: 17),
                    label: const Text('Sign Out'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xFF4B5563)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _navItem(int index, IconData icon, String label) {
    final selected = selectedPage == index;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      child: Material(
        color: selected ? primaryColor : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            openPage(index);
            if (MediaQuery.sizeOf(context).width < 900) {
              Navigator.pop(context);
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 21,
                  color: selected ? Colors.white : const Color(0xFFCBD5E1),
                ),
                const SizedBox(width: 13),
                Text(
                  label,
                  style: TextStyle(
                    color:
                        selected ? Colors.white : const Color(0xFFCBD5E1),
                    fontWeight:
                        selected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                if (index == 5 && lowStockCount > 0) ...[
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.shade400,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$lowStockCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _topBar(String title, bool wide) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      color: Colors.white,
      child: Row(
        children: [
          if (!wide)
            Builder(
              builder: (context) => IconButton(
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: const Icon(Icons.menu),
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: darkColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Inventory management / $title',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Low stock alerts',
            onPressed: () => openPage(5),
            icon: Badge(
              isLabelVisible: lowStockCount > 0,
              label: Text('$lowStockCount'),
              child: const Icon(Icons.notifications_none_rounded),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: const Color(0xFFEEF2FF),
            child: Text(
              widget.userEmail.isNotEmpty
                  ? widget.userEmail[0].toUpperCase()
                  : 'U',
              style: const TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pageContent() {
    switch (selectedPage) {
      case 1:
        return _productsPage();
      case 2:
        return _movementPage(true);
      case 3:
        return _movementPage(false);
      case 4:
        return _transactionsPage();
      case 5:
        return _lowStockPage();
      default:
        return _overviewPage();
    }
  }

  // ==================== OVERVIEW ====================

  Widget _overviewPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Good day!',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Here is what is happening with your inventory today.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _statCard(
                'Total Products',
                '${products.length}',
                Icons.inventory_2_outlined,
                const Color(0xFFEEF2FF),
                primaryColor,
              ),
              _statCard(
                'Total Units',
                '$totalUnits',
                Icons.stacked_bar_chart_rounded,
                const Color(0xFFDCFCE7),
                const Color(0xFF16A34A),
              ),
              _statCard(
                'Inventory Value',
                money(inventoryValue),
                Icons.account_balance_wallet_outlined,
                const Color(0xFFFFF7ED),
                const Color(0xFFEA580C),
              ),
              _statCard(
                'Low Stock Items',
                '$lowStockCount',
                Icons.warning_amber_rounded,
                const Color(0xFFFEE2E2),
                const Color(0xFFDC2626),
              ),
            ],
          ),
          const SizedBox(height: 28),
          const Text(
            'Quick Actions',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _actionButton(
                'Add Product',
                Icons.add_box_outlined,
                addProduct,
              ),
              _actionButton(
                'Stock In',
                Icons.call_received_rounded,
                () => moveStock(true),
              ),
              _actionButton(
                'Stock Out',
                Icons.call_made_rounded,
                () => moveStock(false),
              ),
              _actionButton(
                'All Products',
                Icons.inventory_outlined,
                () => openPage(1),
              ),
            ],
          ),
          const SizedBox(height: 30),
          _sectionHeader('Recent Transactions', () => openPage(4)),
          const SizedBox(height: 12),
          _transactionsTable(limit: 5),
          const SizedBox(height: 28),
          _sectionHeader('Products to Watch', () => openPage(5)),
          const SizedBox(height: 12),
          _lowStockList(),
        ],
      ),
    );
  }

  Widget _statCard(
    String title,
    String value,
    IconData icon,
    Color iconBackground,
    Color iconColor,
  ) {
    return Container(
      width: 235,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 21),
              ),
            ],
          ),
          const SizedBox(height: 18),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: darkColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(
    String label,
    IconData icon,
    VoidCallback action,
  ) {
    return OutlinedButton.icon(
      onPressed: action,
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
        side: const BorderSide(color: Color(0xFFE0E7FF)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, VoidCallback action) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextButton(
          onPressed: action,
          child: const Text('View all'),
        ),
      ],
    );
  }

  // ==================== PRODUCTS ====================

  Widget _productsPage() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: 280,
                child: TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search products...',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    setState(() => searchQuery = value);
                  },
                ),
              ),
              FilledButton.icon(
                onPressed: addProduct,
                icon: const Icon(Icons.add),
                label: const Text('Add Product'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            '${filteredProducts.length} products found',
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _productTable(filteredProducts),
          ),
        ],
      ),
    );
  }

  Widget _productTable(List<Product> list) {
    if (list.isEmpty) {
      return const Center(
        child: Text('No products found. Add a product to get started.'),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: SingleChildScrollView(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(
              const Color(0xFFF8FAFC),
            ),
            columns: const [
              DataColumn(label: Text('PRODUCT')),
              DataColumn(label: Text('CATEGORY')),
              DataColumn(label: Text('PRICE (RWF)')),
              DataColumn(label: Text('QUANTITY')),
              DataColumn(label: Text('STATUS')),
              DataColumn(label: Text('ACTIONS')),
            ],
            rows: list.map((product) {
              return DataRow(
                cells: [
                  DataCell(
                    SizedBox(
                      width: 135,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            product.id,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  DataCell(Text(product.category)),
                  DataCell(Text(money(product.price))),
                  DataCell(Text('${product.quantity}')),
                  DataCell(
                    _statusBadge(
                      product.isLowStock ? 'Low Stock' : 'In Stock',
                      product.isLowStock,
                    ),
                  ),
                  DataCell(
                    Row(
                      children: [
                        IconButton(
                          tooltip: 'Stock In',
                          onPressed: () => moveStock(true),
                          icon: const Icon(
                            Icons.add_circle_outline,
                            color: Colors.green,
                          ),
                        ),
                        IconButton(
                          tooltip: 'Stock Out',
                          onPressed: () => moveStock(false),
                          icon: const Icon(
                            Icons.remove_circle_outline,
                            color: Colors.orange,
                          ),
                        ),
                        IconButton(
                          tooltip: 'Delete product',
                          onPressed: () => deleteProduct(product),
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Future<void> deleteProduct(Product product) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete product?'),
        content: Text('Remove "${product.name}" from the inventory?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() {
        products.remove(product);
      });
      notify('Product deleted.');
    }
  }

  Widget _statusBadge(String text, bool warning) {
    final color = warning ? Colors.red : Colors.green;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ==================== STOCK MOVEMENTS ====================

  Widget _movementPage(bool stockIn) {
    final list = movements.where((m) => m.type == (stockIn ? 'IN' : 'OUT'));

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stockIn ? 'Receive Stock' : 'Issue Stock',
                        style: const TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        stockIn
                            ? 'Record newly received inventory.'
                            : 'Record inventory leaving your store.',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Icon(
                  stockIn ? Icons.call_received : Icons.call_made,
                  size: 38,
                  color: stockIn ? Colors.green : Colors.orange,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => moveStock(stockIn),
            icon: const Icon(Icons.add),
            label: Text(stockIn ? 'Record Stock In' : 'Record Stock Out'),
          ),
          const SizedBox(height: 24),
          Text(
            'Recent ${stockIn ? 'Stock In' : 'Stock Out'} Records',
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _transactionsTable(
              limit: movements.length,
              type: stockIn ? 'IN' : 'OUT',
            ),
          ),
          Text(
            '${list.length} records',
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // ==================== TRANSACTIONS ====================

  Widget _transactionsPage() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Inventory Transactions',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Review recorded stock receipts and issues.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: _transactionsTable(limit: movements.length),
          ),
        ],
      ),
    );
  }

  Widget _transactionsTable({
    required int limit,
    String? type,
  }) {
    final list = movements
        .where((movement) => type == null || movement.type == type)
        .take(limit)
        .toList();

    if (list.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Text('No transactions recorded yet.'),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: DataTable(
            columns: const [
              DataColumn(label: Text('PRODUCT')),
              DataColumn(label: Text('TYPE')),
              DataColumn(label: Text('QUANTITY')),
              DataColumn(label: Text('DATE')),
              DataColumn(label: Text('NOTE')),
            ],
            rows: list.map((movement) {
              final isIn = movement.type == 'IN';

              return DataRow(
                cells: [
                  DataCell(Text(movement.productName)),
                  DataCell(
                    _statusBadge(
                      isIn ? 'Stock In' : 'Stock Out',
                      !isIn,
                    ),
                  ),
                  DataCell(
                    Text(
                      '${isIn ? '+' : '-'}${movement.quantity}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isIn ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                  DataCell(Text(
                    '${movement.date.day.toString().padLeft(2, '0')}/'
                    '${movement.date.month.toString().padLeft(2, '0')}/'
                    '${movement.date.year} '
                    '${movement.date.hour.toString().padLeft(2, '0')}:'
                    '${movement.date.minute.toString().padLeft(2, '0')}',
                  )),
                  DataCell(Text(movement.note)),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  // ==================== LOW STOCK ====================

  Widget _lowStockPage() {
    final lowProducts = products.where((p) => p.isLowStock).toList();

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Low Stock Alerts',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Products that have reached or fallen below their minimum level.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          if (lowProducts.isEmpty)
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 64,
                      color: Colors.green,
                    ),
                    SizedBox(height: 12),
                    Text('All products are sufficiently stocked.'),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: _productTable(lowProducts),
            ),
        ],
      ),
    );
  }

  Widget _lowStockList() {
    final lowProducts = products.where((p) => p.isLowStock).toList();

    if (lowProducts.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Text('All products are above their minimum stock level.'),
      );
    }

    return Column(
      children: lowProducts.take(5).map((product) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '${product.category} • Minimum: ${product.minimumStock}',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${product.quantity} left',
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ==================== ADD PRODUCT DIALOG ====================

class ProductDialog extends StatefulWidget {
  const ProductDialog({super.key});

  @override
  State<ProductDialog> createState() => _ProductDialogState();
}

class _ProductDialogState extends State<ProductDialog> {
  final formKey = GlobalKey<FormState>();
  final idController = TextEditingController();
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController(text: '0');
  final minimumController = TextEditingController(text: '5');

  String category = 'General';

  final categories = const [
    'General',
    'Electronics',
    'Stationery',
    'Furniture',
    'Food & Beverage',
    'Clothing',
    'Other',
  ];

  @override
  void dispose() {
    idController.dispose();
    nameController.dispose();
    priceController.dispose();
    quantityController.dispose();
    minimumController.dispose();
    super.dispose();
  }

  String? requiredText(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? requiredNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Required';
    }
    final number = double.tryParse(value);
    if (number == null || !number.isFinite || number < 0) {
      return 'Enter a valid non-negative number';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Product'),
      content: SizedBox(
        width: 440,
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: idController,
                  decoration: const InputDecoration(
                    labelText: 'Product ID / SKU',
                    hintText: 'e.g. PRD-005',
                  ),
                  validator: requiredText,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Product Name',
                  ),
                  validator: requiredText,
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  value: category,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: categories.map((item) {
                    return DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => category = value);
                  },
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: priceController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d*\.?\d*'),
                    ),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Unit Price (RWF)',
                  ),
                  validator: requiredNumber,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Opening Quantity',
                  ),
                  validator: requiredNumber,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: minimumController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Minimum Stock Alert Level',
                  ),
                  validator: requiredNumber,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (!formKey.currentState!.validate()) return;

            final product = Product(
              id: idController.text.trim(),
              name: nameController.text.trim(),
              category: category,
              price: double.parse(priceController.text),
              quantity: int.parse(quantityController.text),
              minimumStock: int.parse(minimumController.text),
            );

            Navigator.pop(context, product);
          },
          child: const Text('Save Product'),
        ),
      ],
    );
  }
}

// ==================== STOCK MOVEMENT DIALOG ====================

class MovementDialog extends StatefulWidget {
  final List<Product> products;
  final bool isStockIn;

  const MovementDialog({
    super.key,
    required this.products,
    required this.isStockIn,
  });

  @override
  State<MovementDialog> createState() => _MovementDialogState();
}

class _MovementDialogState extends State<MovementDialog> {
  final formKey = GlobalKey<FormState>();
  final quantityController = TextEditingController();
  final noteController = TextEditingController();

  Product? selectedProduct;

  @override
  void initState() {
    super.initState();
    selectedProduct = widget.products.first;
  }

  @override
  void dispose() {
    quantityController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stockIn = widget.isStockIn;

    return AlertDialog(
      title: Text(stockIn ? 'Receive Stock' : 'Issue Stock'),
      content: SizedBox(
        width: 420,
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<Product>(
                  value: selectedProduct,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Select Product',
                  ),
                  items: widget.products.map((product) {
                    return DropdownMenuItem(
                      value: product,
                      child: Text(
                        '${product.name} (${product.quantity} available)',
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (product) {
                    setState(() => selectedProduct = product);
                  },
                  validator: (product) =>
                      product == null ? 'Select a product' : null,
                ),
                const SizedBox(height: 16),
                if (!stockIn && selectedProduct != null)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        'Available quantity: ${selectedProduct!.quantity}',
                        style: const TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                TextFormField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Quantity',
                    hintText: 'Enter quantity',
                  ),
                  validator: (value) {
                    final quantity = int.tryParse(value ?? '');

                    if (quantity == null || quantity <= 0) {
                      return 'Enter a quantity greater than zero';
                    }

                    if (!stockIn &&
                        selectedProduct != null &&
                        quantity > selectedProduct!.quantity) {
                      return 'Quantity exceeds available stock';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: noteController,
                  decoration: const InputDecoration(
                    labelText: 'Note (optional)',
                    hintText: 'Supplier, reason, reference...',
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (!formKey.currentState!.validate()) return;

            Navigator.pop(context, {
              'product': selectedProduct,
              'quantity': int.parse(quantityController.text),
              'note': noteController.text.trim(),
            });
          },
          child: Text(stockIn ? 'Confirm Stock In' : 'Confirm Stock Out'),
        ),
      ],
    );
  }
}
