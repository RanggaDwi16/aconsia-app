import 'package:aconsia_app/core/ui/components/aconsia_screen_shell.dart';
import 'package:aconsia_app/core/ui/tokens/ui_spacing.dart';
import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HelpdeskPage extends StatelessWidget {
  const HelpdeskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
        padding: const EdgeInsets.all(UiSpacing.lg),
        children: [
          AconsiaTopActionRow(
            title: 'Tutorial',
            subtitle: 'Panduan cepat penggunaan aplikasi ACONSIA',
            onBack: () => Navigator.of(context).pop(),
          ),
          const Gap(UiSpacing.md),
          _buildExpansionTile(
            title: 'Cara mendaftar dan mengakses akun Aconsia',
            content: '1. Buka aplikasi dan pilih "Daftar".\n'
                '2. Isi data pribadi seperti nama, email, dan password.\n'
                '3. Verifikasi email melalui link yang dikirim.\n'
                '4. Setelah terverifikasi, masuk menggunakan email dan password.',
          ),
          Gap(UiSpacing.md),
          _buildExpansionTile(
            title: 'Reset Password',
            content: '1. Pilih "Lupa Password" pada layar login.\n'
                '2. Masukkan email yang terdaftar dan ikuti instruksi yang dikirim ke email.',
          ),
          Gap(UiSpacing.md),
          _buildExpansionTile(
            title: 'Kontak Bantuan',
            content:
                'Jika masih ada masalah, hubungi tim support di support@example.com atau 0800-123-456.',
          ),
        ],
        ),
      ),
    );
  }

  Widget _buildExpansionTile({
    required String title,
    required String content,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: UiPalette.slate300,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Theme(
        data: ThemeData(
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: ExpansionTile(
          title: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: UiPalette.slate900,
            ),
          ),
          tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 16,
            top: 0,
          ),
          iconColor: UiPalette.slate500,
          collapsedIconColor: UiPalette.slate500,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                content,
                style: TextStyle(
                  fontSize: 13,
                  color: UiPalette.slate500,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
