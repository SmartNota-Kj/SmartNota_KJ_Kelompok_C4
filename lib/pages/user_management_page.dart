import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../themes/app_theme.dart';
import '../models/user_model.dart';
import '../providers/auth_provider.dart';
import 'login_page.dart';
import '../widgets/app_widgets.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  final _db = Supabase.instance.client;
  List<UserModel> _users = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadUsers());
  }

  Future<void> _loadUsers() async {
    setState(() => _loading = true);
    try {
      final res = await _db
          .from('profiles')
          .select()
          .order('created_at', ascending: false);
      _users = (res as List).map((e) => UserModel.fromJson(e)).toList();
    } catch (_) {}
    setState(() => _loading = false);
  }

  Future<void> _toggleActive(UserModel user) async {
    await _db
        .from('profiles')
        .update({'is_active': !user.isActive}).eq('id', user.id);
    await _loadUsers();
  }

  // ── Dialog: Tambah Admin ───────────────────────────────────────────────────

  void _showAddAdminDialog() {
    final emailCtrl = TextEditingController();
    final nameCtrl = TextEditingController();
    final passwordCtrl = TextEditingController();
    bool isLoading = false;
    bool obscure = true;

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.45),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setS) => Dialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.person_add_rounded,
                          color: AppTheme.primary, size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Tambah Admin Baru',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2C1A1A),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _FieldLabel(label: 'Email'),
                const SizedBox(height: 6),
                _StyledTextField(
                  controller: emailCtrl,
                  hint: 'admin@example.com',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                ),
                const SizedBox(height: 16),
                _FieldLabel(label: 'Nama Lengkap'),
                const SizedBox(height: 6),
                _StyledTextField(
                  controller: nameCtrl,
                  hint: 'Nama lengkap admin',
                  prefixIcon: Icons.person_outline_rounded,
                ),
                const SizedBox(height: 16),
                _FieldLabel(label: 'Password'),
                const SizedBox(height: 6),
                _StyledTextField(
                  controller: passwordCtrl,
                  hint: 'Minimal 6 karakter',
                  obscureText: obscure,
                  prefixIcon: Icons.lock_outline_rounded,
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 18,
                      color: AppTheme.textSecondary,
                    ),
                    onPressed: () => setS(() => obscure = !obscure),
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed:
                            isLoading ? null : () => Navigator.pop(ctx),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.textSecondary,
                          side: BorderSide(color: AppTheme.border),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          minimumSize: const Size(0, 46),
                        ),
                        child: const Text('Batal',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () async {
                                if (emailCtrl.text.trim().isEmpty ||
                                    nameCtrl.text.trim().isEmpty ||
                                    passwordCtrl.text.trim().isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Semua field harus diisi'),
                                      backgroundColor: AppTheme.danger,
                                    ),
                                  );
                                  return;
                                }
                                if (passwordCtrl.text.length < 6) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Password minimal 6 karakter'),
                                      backgroundColor: AppTheme.danger,
                                    ),
                                  );
                                  return;
                                }
                                setS(() => isLoading = true);
                                try {
                                  final authResponse =
                                      await _db.auth.signUp(
                                    email: emailCtrl.text.trim(),
                                    password: passwordCtrl.text.trim(),
                                  );
                                  if (authResponse.user != null) {
                                    await _db.from('profiles').insert({
                                      'id': authResponse.user!.id,
                                      'email': emailCtrl.text.trim(),
                                      'full_name': nameCtrl.text.trim(),
                                      'role': 'admin',
                                      'is_active': true,
                                    });
                                    if (mounted) {
                                      Navigator.pop(ctx);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content:
                                            Text('Admin berhasil ditambahkan'),
                                        backgroundColor: AppTheme.success,
                                      ));
                                      await _loadUsers();
                                    }
                                  }
                                } catch (e) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Gagal menambah admin: ${e.toString()}'),
                                        backgroundColor: AppTheme.danger,
                                      ),
                                    );
                                  }
                                } finally {
                                  setS(() => isLoading = false);
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          minimumSize: const Size(0, 46),
                          elevation: 0,
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white),
                              )
                            : const Text('Tambah Admin',
                                style: TextStyle(fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Dialog: Edit Pengguna ──────────────────────────────────────────────────

  void _showEditDialog(UserModel user) {
    final nameCtrl = TextEditingController(text: user.fullName);
    String role = user.role;

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.45),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setS) => Dialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.edit_rounded,
                          color: AppTheme.primary, size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Edit Pengguna',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2C1A1A),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _FieldLabel(label: 'Nama Lengkap'),
                const SizedBox(height: 6),
                _StyledTextField(
                  controller: nameCtrl,
                  hint: 'Nama lengkap',
                  prefixIcon: Icons.person_outline_rounded,
                ),
                const SizedBox(height: 16),
                _FieldLabel(label: 'Peran'),
                const SizedBox(height: 6),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F7F5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.border),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: role,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded,
                          color: AppTheme.textSecondary),
                      style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF2C1A1A),
                          fontWeight: FontWeight.w500),
                      items: const [
                        DropdownMenuItem(
                            value: 'supervisor', child: Text('Supervisor')),
                        DropdownMenuItem(
                            value: 'admin', child: Text('Admin')),
                      ],
                      onChanged: (v) => setS(() => role = v!),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.textSecondary,
                          side: BorderSide(color: AppTheme.border),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          minimumSize: const Size(0, 46),
                        ),
                        child: const Text('Batal',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () async {
                          await _db.from('profiles').update({
                            'full_name': nameCtrl.text.trim(),
                            'role': role,
                          }).eq('id', user.id);
                          if (mounted) Navigator.pop(ctx);
                          await _loadUsers();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          minimumSize: const Size(0, 46),
                          elevation: 0,
                        ),
                        child: const Text('Simpan Perubahan',
                            style: TextStyle(fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Dialog: Konfirmasi Toggle Aktif ───────────────────────────────────────

  Future<void> _confirmToggle(UserModel user) async {
    final isDeactivate = user.isActive;

    final confirm = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.45),
      builder: (_) => Dialog(
        backgroundColor: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding:
            const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: isDeactivate
                      ? AppTheme.danger.withOpacity(0.1)
                      : AppTheme.success.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isDeactivate
                      ? Icons.block_rounded
                      : Icons.check_circle_outline_rounded,
                  color: isDeactivate ? AppTheme.danger : AppTheme.success,
                  size: 28,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isDeactivate ? 'Nonaktifkan Pengguna' : 'Aktifkan Pengguna',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2C1A1A),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                isDeactivate
                    ? 'Akun ${user.fullName} akan dinonaktifkan dan tidak bisa login.'
                    : 'Akun ${user.fullName} akan diaktifkan kembali.',
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF9A8A8A),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.textSecondary,
                        side: BorderSide(color: AppTheme.border),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        minimumSize: const Size(0, 46),
                      ),
                      child: const Text('Batal',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isDeactivate ? AppTheme.danger : AppTheme.success,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        minimumSize: const Size(0, 46),
                        elevation: 0,
                      ),
                      child: Text(
                        isDeactivate ? 'Nonaktifkan' : 'Aktifkan',
                        style:
                            const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirm == true) await _toggleActive(user);
  }


  Future<void> _logout() async {
    await context.read<AuthProvider>().logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final me = context.read<AuthProvider>().currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Pengguna'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu_rounded,
                color: Color.fromRGBO(255, 255, 255, 1)),
            onSelected: (value) {
              if (value == 'logout') _logout();
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout_rounded,
                        color: AppTheme.danger, size: 20),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [AppTheme.primary, AppTheme.primaryDark]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  _Avatar(name: me?.fullName ?? 'S', size: 50, light: true),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(me?.fullName ?? '',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 15)),
                        Text(me?.email ?? '',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 12)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20)),
                    child: const Text('Supervisor',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Text('${_users.length} pengguna',
                    style: const TextStyle(
                        color: AppTheme.textSecondary, fontSize: 13)),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.refresh_rounded, size: 20),
                  onPressed: _loadUsers,
                  tooltip: 'Refresh',
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: const Icon(Icons.person_add_rounded, size: 20),
                  onPressed: _showAddAdminDialog,
                  tooltip: 'Tambah Admin',
                ),
              ],
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _users.isEmpty
                    ? const EmptyState(
                        icon: Icons.people_outline,
                        title: 'Belum ada pengguna')
                    : RefreshIndicator(
                        onRefresh: _loadUsers,
                        child: ListView.separated(
                          padding:
                              const EdgeInsets.fromLTRB(16, 0, 16, 32),
                          itemCount: _users.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                          itemBuilder: (_, i) {
                            final u = _users[i];
                            return _UserTile(
                              user: u,
                              isSelf: u.id == me?.id,
                              onEdit: () => _showEditDialog(u),
                              onToggle: () => _confirmToggle(u),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: Color(0xFF5A3A3A),
        letterSpacing: 0.2,
      ),
    );
  }
}

class _StyledTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final Widget? suffixIcon;

  const _StyledTextField({
    required this.controller,
    required this.hint,
    this.obscureText = false,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 14, color: Color(0xFF2C1A1A)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            const TextStyle(fontSize: 13, color: Color(0xFFB8A8A8)),
        filled: true,
        fillColor: const Color(0xFFF8F7F5),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, size: 18, color: AppTheme.textSecondary)
            : null,
        suffixIcon: suffixIcon,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.primary, width: 1.5),
        ),
      ),
    );
  }
}

class _UserTile extends StatelessWidget {
  final UserModel user;
  final bool isSelf;
  final VoidCallback onEdit;
  final VoidCallback onToggle;

  const _UserTile({
    required this.user,
    required this.isSelf,
    required this.onEdit,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final roleColor =
        user.role == 'supervisor' ? AppTheme.primary : AppTheme.secondary;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          _Avatar(name: user.fullName, size: 44),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Flexible(
                    child: Text(user.fullName,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 13),
                        overflow: TextOverflow.ellipsis),
                  ),
                  if (isSelf) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                          color: AppTheme.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6)),
                      child: const Text('Saya',
                          style: TextStyle(
                              fontSize: 10,
                              color: AppTheme.success,
                              fontWeight: FontWeight.w700)),
                    ),
                  ],
                ]),
                Text(user.email,
                    style: const TextStyle(
                        fontSize: 11, color: AppTheme.textSecondary),
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 5),
                Row(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                        color: roleColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6)),
                    child: Text(
                      user.role == 'supervisor' ? 'Supervisor' : 'Admin',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: roleColor),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                        color: user.isActive
                            ? AppTheme.success
                            : AppTheme.danger,
                        shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 4),
                  Text(user.isActive ? 'Aktif' : 'Nonaktif',
                      style: TextStyle(
                          fontSize: 10,
                          color: user.isActive
                              ? AppTheme.success
                              : AppTheme.danger)),
                ]),
              ],
            ),
          ),
          if (!isSelf) ...[
            IconButton(
              icon: const Icon(Icons.edit_outlined,
                  size: 18, color: AppTheme.primary),
              onPressed: onEdit,
            ),
            IconButton(
              icon: Icon(
                user.isActive
                    ? Icons.block_rounded
                    : Icons.check_circle_outline_rounded,
                size: 18,
                color: user.isActive ? AppTheme.danger : AppTheme.success,
              ),
              onPressed: onToggle,
            ),
          ],
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String name;
  final double size;
  final bool light;

  const _Avatar(
      {required this.name, required this.size, this.light = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: light
            ? Colors.white.withOpacity(0.2)
            : AppTheme.primary.withOpacity(0.12),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          name.substring(0, 1).toUpperCase(),
          style: TextStyle(
            color: light ? Colors.white : AppTheme.primary,
            fontWeight: FontWeight.w800,
            fontSize: size * 0.38,
          ),
        ),
      ),
    );
  }
}