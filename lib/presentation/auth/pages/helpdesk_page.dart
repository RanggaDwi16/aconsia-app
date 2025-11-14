import 'package:aconsia_app/core/helpers/custom_app_bar.dart';
import 'package:aconsia_app/core/utils/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HelpdeskPage extends StatelessWidget {
  const HelpdeskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Tutorial',
        centertitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildExpansionTile(
            title: 'Cara mendaftar dan mengakses akun Aconsia',
            content: '1. Buka aplikasi dan pilih "Daftar".\n'
                '2. Isi data pribadi seperti nama, email, dan password.\n'
                '3. Verifikasi email melalui link yang dikirim.\n'
                '4. Setelah terverifikasi, masuk menggunakan email dan password.',
          ),
          Gap(12),
          _buildExpansionTile(
            title: 'Reset Password',
            content: '1. Pilih "Lupa Password" pada layar login.\n'
                '2. Masukkan email yang terdaftar dan ikuti instruksi yang dikirim ke email.',
          ),
          Gap(12),
          _buildExpansionTile(
            title: 'Kontak Bantuan',
            content:
                'Jika masih ada masalah, hubungi tim support di support@example.com atau 0800-123-456.',
          ),
        ],
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
          color: AppColor.borderColor,
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
              color: AppColor.textColor,
            ),
          ),
          tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 16,
            top: 0,
          ),
          iconColor: AppColor.textGrayColor,
          collapsedIconColor: AppColor.textGrayColor,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                content,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColor.textGrayColor,
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
